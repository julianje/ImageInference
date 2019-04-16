from Bishop import *
import itertools as it
import csv
import matplotlib.pyplot as plt
import numpy as np

# Get State id from x,y coordinates
def TranslateState(coords): return (coords[0])*O.Plr.Map.mapwidth+coords[1]
# Get probability that agent generates scene, either before or after collecting the goal
def SceneLikelihood(Observer, Scene, rollouts=10000, verbose=True):
	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	# Return: (1) agent's rewards, agent's probability of pursuing each object, likelihood of generating the scene, markers of which samples matched the scene, and AgentSimulation object (see AgentSimulation.py)
	SceneMatches = [Scene in x for x in Simulations.States]
	return([O.Plr.Agent.rewards,O.Plr.GetPlanDistribution(),sum(SceneMatches)*1.0/rollouts,SceneMatches,Simulations])

# Get probability that agent generates scene, either *before* collecting the goal
def SceneLikelihoodPreGoal(Observer, Scene, rollouts=10000, verbose=True):
	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	# Hacky solution: Check first half of the path since the agent returns to their starting point.
	SceneMatches = [Scene in x[0:len(x)/2] for x in Simulations.States]
	return([O.Plr.Agent.rewards,O.Plr.GetPlanDistribution(),sum(SceneMatches)*1.0/rollouts,SceneMatches,Simulations])

##############
# Parameters #
##############
TrialName = "Trial C"
verbose = False
World = "RoomA"
# 5th row down, 4rth left. Starts from 0
#Observation = [5,4]  # Trial A
#Observation = [8,5] # Trial B
Observation = [4,7]
Samples = 100
rollouts = 1000

#############
# Run model #
#############
O = LoadObserver(World, Silent= not verbose)
Scene = TranslateState(Observation)
Results = [-1]*Samples
for i in range(Samples):
	sys.stdout.write("Reward function #"+str(i+1)+"\n")
	O.Plr.Agent.ResampleAgent()
	# Run the planner manually since SceneLikelihood has planning turned off on SimulateAgents
	O.Plr.Prepare(Validate=False) # Don't check for inconsistencies in model so that code runs faster
	Results[i] = SceneLikelihoodPreGoal(O, Scene, rollouts, verbose)

##########################
## Now do stuff with the joint distribution
#########################
# Get normalizing constant over reward functons:
RNormalizer = sum([Results[i][2] for i in range(len(Results))])
# Normalize samples:
for i in range(len(Results)):
	Results[i][2] /= RNormalizer

# Get Probability that agent pursues each goal:
##############################################
GoalProbs= [sum([Results[sample][1][goal]*Results[sample][2] for sample in range(len(Results))]) for goal in range(len(O.Plr.Map.ObjectLocations))]
GoalNames=O.Plr.Map.ObjectNames

plt.clf()
xvals = np.arange(len(GoalNames))
plt.bar(xvals,GoalProbs,align='center',alpha=0.5)
plt.xticks(xvals,GoalNames)
plt.ylabel('Probability')
axes = plt.gca()
axes.set_ylim([0,1])
plt.title(TrialName)
plt.savefig(TrialName+".png")

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
File = 'Posterior_States_' + TrialName + ".csv"
with open(File,mode='w') as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	ObservationLength=max([max([len(x) for x in Results[i][4].States]) for i in range(len(Results))])
	model_writer.writerow(['MapHeight','MapWidth','Scene','Probability']+["Obs"+str(i) for i in range(ObservationLength)])
	[model_writer.writerow([O.Plr.Map.mapheight,O.Plr.Map.mapwidth,Scene,InferredStates[1][i]]+list(InferredStates[0][i])) for i in range(len(InferredStates[1]))]

File = 'Posterior_Actions' + TrialName + ".csv"
with open(File,mode='w') as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",")
	ObservationLength=max([max([len(x) for x in Results[i][4].Actions]) for i in range(len(Results))])
	model_writer.writerow(['MapHeight','MapWidth','Scene','Probability']+["Obs"+str(i) for i in range(ObservationLength)])
	[model_writer.writerow([O.Plr.Map.mapheight,O.Plr.Map.mapwidth,Scene,InferredActions[1][i]]+list(InferredActions[0][i])) for i in range(len(InferredActions[1]))]
