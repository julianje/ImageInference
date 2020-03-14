from Bishop import *

import csv
import itertools as it
import matplotlib.pyplot as plt
import numpy as np
import sys

# Transform x- and y-coordinates into a state representation.
def transform_state(agent, coords):
	return (coords[0]*agent.Plr.Map.mapwidth) + coords[1]

def scene_likelihood(agent, scene, num_paths, stage="entering"):
	simulations = observer.SimulateAgents(num_paths, ResampleAgent=False, 
		Verbose=False, replan=False)
	if stage == "entering":
		scene_matches = [scene in states[0:len(states)/2] \
			for states in simulations.States]
	if stage == "exiting":
		scene_matches = [scene in states[len(states)/2:len(states)] \
			for x in Simulations.States]
	if stage == "either":
		scene_matches = [scene in states for states in Simulations.States]
	return([agent.Plr.Agent.rewards, agent.Plr.GetPlanDistribution(), 
		sum(scene_matches)*1.0/num_paths, scene_matches, simulations])

# Get probability that agent generates scene, either *before* collecting the goal
# def SceneLikelihood(Observer, Scene, rollouts=10000, verbose=True, Stage="Entering"):
# 	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
# 	if Stage=="Entering":
# 		SceneMatches = [Scene in x[0:len(x)/2] for x in Simulations.States]
# 	if Stage=="Exiting":
# 		SceneMatches = [Scene in x[len(x)/2:len(x)] for x in Simulations.States]
# 	if Stage=="Either":
# 		SceneMatches = [Scene in x for x in Simulations.States]
# 	return([Observer.Plr.Agent.rewards, Observer.Plr.GetPlanDistribution(), sum(SceneMatches)*1.0/rollouts, 
# 		SceneMatches, Simulations])

# Inference parameters
verbose = False
stage = "entering"
samples = int(sys.argv[2])
num_paths = 1000
path = "data/model/predictions/Manhattan/"

# Uncomment these lines if running on the cluster or as batch.
# TrialName = sys.argv[1]
# World = sys.argv[1]
# Doors = [[int(num) for num in pair.split(" ")] for pair in sys.argv[2].split("-")]
# Observation = [int(num) for num in sys.argv[3].split(" ")]
# plt.switch_backend('agg')

# Uncomment these lines if running locally.
# TrialName = "PX_NX_0"
# World = "PX_NX_0"
# Doors = [[64, 65], [106, 117], [67, 66]]
# Observation = [4, 7]
world = sys.argv[1]
doors = [[16, 5], [56, 55]]
observation = [6, 4]

print(world)

#############
# Run model #
#############
agent = LoadObserver("stimuli/experiment_1/"+world, Silent = not verbose)
scene = transform_state(observation)
results = [-1] * samples
entrance = [-1] * samples
for i in range(samples):
	print("Reward function #"+str(i+1))

	# Sample which door this agent uses.
	door = random.choice(doors)
	agent.SetStartingPoint(door[0], Verbose=False)
	agent.Plr.Map.ExitState = door[1]

	# Sample a reward function for this agent.
	agent.Plr.Agent.ResampleAgent()
	# Run the planner manually since SceneLikelihood has planning turned off on SimulateAgents
	agent.Plr.Prepare(Validate=False) # Don't check for inconsistencies in model so that code runs faster

	results[i] = SceneLikelihood(agent, scene, num_paths, verbose, stage=stage)
	entrance[i] = door[0]

sys.exit()

##########################
## Now do stuff with the joint distribution
#########################
# Get normalizing constant over reward functions:
RNormalizer = sum([Results[i][2] for i in range(len(Results))])
# Normalize samples:
for i in range(len(Results)):
	Results[i][2] /= RNormalizer
	# if RNormalizer != 0:
	# 	Results[i][2] /= RNormalizer

# Get Probability that agent pursues each goal:
##############################################
GoalProbs= [sum([Results[sample][1][goal]*Results[sample][2] for sample in range(len(Results))]) for goal in range(len(O.Plr.Map.ObjectLocations))]
GoalNames=O.Plr.Map.ObjectNames

# plt.figure(1)
# xvals = np.arange(len(GoalNames))
# plt.bar(xvals,GoalProbs,align='center',alpha=0.5)
# plt.xticks(xvals,GoalNames)
# plt.ylabel('Probability')
# axes = plt.gca()
# axes.set_ylim([0,1])
# plt.title(TrialName)
# plt.savefig(path+TrialName+".png")
# plt.close(1)

# Get Posterior over states and actions:
########################################
# Put the samples in a dictionary
ActionPosterior = {}
StatePosterior = {}
for R in Results:
	# Second entry encodes entire likelihood of reward function.
	# So if reward function can't generate scene then don't bother.
	if R[2] != 0:
		# R[3] has a boolean vector of which samples match image
		for sampleno in range(len(R[3])):
			action = R[4].Actions[sampleno]
			states = R[4].States[sampleno]
			ImageMatch = R[3][sampleno]
			# If action will have probability zero because it never matched scene, then don't bother.
			if ImageMatch:
				# If action is already in dictionary just add the new probability.
				if tuple(action) in ActionPosterior:
					ActionPosterior[tuple(action)] += R[2] # Likelihood of reward function * likelihood of action generating scene
				else:
					ActionPosterior[tuple(action)] = R[2]
				# Same for scenes
				if tuple(states) in StatePosterior:
					StatePosterior[tuple(states)] += R[2] # Likelihood of reward function * likelihood of action generating scene
				else:
					StatePosterior[tuple(states)] = R[2]

# Remove dictionary ugliness and normalize
ca = sum(ActionPosterior.values())
InferredActions = [ActionPosterior.keys(),ActionPosterior.values()]
InferredActions[1] = [x/ca for x in InferredActions[1]]

cb = sum(StatePosterior.values())
InferredStates = [StatePosterior.keys(),StatePosterior.values()]
InferredStates[1] = [x/cb for x in InferredStates[1]]

# Save state and action posterior
# as a csv so we can visualize them in R
filename = path + world + "_States_Posterior.csv"
with open(filename, "w") as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	observation_length = max([len(x) for x in inferred_states[0]])
	#ObservationLength=max([max([len(x) for x in Results[i][4].States]) for i in range(len(Results))])
	model_writer.writerow(["MapHeight", "MapWidth", "Scene", "Probability"]+["Obs"+str(i) for i in range(observation_length)])
	[model_writer.writerow(
		[agent.Plr.Map.mapheight,agent.Plr.Map.mapwidth,Scene,InferredStates[1][i]]+list(InferredStates[0][i])) for i in range(len(InferredStates[1]))]

File = path + TrialName + "_Actions_Posterior.csv"
with open(File,mode='w') as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	ObservationLength=ObservationLength-1 # It will just be one less  than states above.
	model_writer.writerow(['MapHeight','MapWidth','Scene','Probability']+["Obs"+str(i) for i in range(ObservationLength)])
	[model_writer.writerow([O.Plr.Map.mapheight,O.Plr.Map.mapwidth,Scene,InferredActions[1][i]]+list(InferredActions[0][i])) for i in range(len(InferredActions[1]))]

File = path + TrialName + "_Goal_Posterior.csv"
with open(File,mode='w') as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	model_writer.writerow(['Goal','Probability'])
	[model_writer.writerow([GoalNames[i],GoalProbs[i]]) for i in range(len(GoalNames))]

# Create CSV with time estimate:
ImageStep = [x.index(Scene) for x in InferredStates[0]]
StepLength = [len(x) for x in InferredStates[0]]
Probabilities = InferredStates[1]

File = path + TrialName + "_Time_Estimates.csv"
with open(File,mode='w') as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	model_writer.writerow(['Step','PathLength','Probability'])
	[model_writer.writerow([ImageStep[i],StepLength[i],Probabilities[i]]) for i in range(len(Probabilities))]
