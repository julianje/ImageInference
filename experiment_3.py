import csv
import itertools as it
import matplotlib.pyplot as plt
import numpy as np
import sys

from Bishop import *

# Transform x- and y-coordinates into a state representation.
def transform_state(agent, coords):
	return (coords[0]*agent.Plr.Map.mapwidth) + coords[1]

# Computes the likelihood that one agent was in the room based on the 
# observations. 
# NOTE: This function assumes agents are entering the room.
def scene_likelihood_one_agent(agent, observations, num_paths):
	# Generate paths according to the current map and policy.
	simulations = agent.SimulateAgents(num_paths, ResampleAgent=False, 
		Simple=False, Verbose=False, replan=False)

	# Iterate through each path and check if it's consistent with the 
	# observations.
	scene_matches = np.zeros(num_paths)
	for i in range(len(simulations.States)):
		# Take the set intersection of the observations and this path.
		intersection = set(observations).intersection(set( \
			simulation.States[i][0:lne(simulation.States[i])/2]))

		# Check if this path explains the observations.
		scene_matches = 1.0 if intersection == set(observations) else 0.0

	return([
		agent.Plr.Agent.rewards,
		agent.Plr.GetPlanDistribution(),
		sum(scene_matches)*1.0/num_paths,
		scene_matches,
		simulations
	])

# Computes the likelihood that two agents were in the room based on the 
# observations. 
# NOTE: This function assumes agents are entering the room.
def scene_likelihood_two_agents(agent_0, agent_1, observations, num_paths):
	# Generate paths according to the current map and policy.
	simulations_0 = agent_0.SimulateAgents(rollouts, ResampleAgent=False, \
		Simple=False, Verbose=False, replan=False),
	simulations_1 = agent_1.SimulateAgents(rollouts, ResampleAgent=False, \
		Simple=False, Verbose=False, replan=False)

	# Iterate through each pair of pahts and check if they're consistent with 
	# the observations.
	scene_matches = np.zeros(num_paths)
	for i in range(len(simulations[0].States)):
		# Take the set intersection of the observations and both paths.
		intersection_0 = set(observations).intersection(set( \
			simulations_0.States[i][0:len(simulations_0.States[i])/2]))
		intersection_1 = set(observations).intersection(set( \
			simulations_1.States[i][0:len(simulations_1.States[i])/2]))

		# Check if each path explains exactly one of the observations.
		if (len(intersection_0) == 1 and len(intersection_1) == 1) \
			and intersection_0.union(intersection_1) == set(observations):
			scene_matches[i] = 1.0
		else:
			scene_matches[i] = 0.0

	return([
		[
			agent_0.Plr.Agent.rewards, 
			agent_0.Plr.GetPlanDistribution(), 
			sum(scene_matches)*1.0/num_paths, 
			scene_matches,
			simulations_0
		], 
		[
			agent_1.Plr.Agent.rewards, 
			agent_1.Plr.GetPlanDistribution(), 
			sum(scene_matches)*1.0/num_paths, 
			scene_matches, 
			simulations_1
		]
	])

# Number of reward functions to sample.
samples = 1000

# Number of paths to sample (per reward function).
num_paths = 1000

# Determine how much information we want to output.
verbose = False

# Set the path for saving data.
path = "data/experiment_3/model/predictions/"

# Set whether we are using the cluster or not, then load the trial information.
world = sys.argv[1]
doors = [[int(num) for num in pair.split(" ")] for pair in sys.argv[2].split("-")]
observations = [[int(num) for num in pair.split(" ")] for pair in sys.argv[3].split("-")]


agent_0 = LoadObserver("stimuli/experiment_3/"+world, Silent=True),
agent_1 = LoadObserver("stimuli/experiment_3/"+world, Silent=True)
Scene = [TranslateState(Agents[0], Obs) for Obs in Observation]
results_one_agent = [-1] * samples
results_two_agents = [-1] * samples
for i in range(Samples):
	print("Reward function #"+str(i+1))

	door_0 = random.choice(doors)
	agent_0.SetStartingPoint(door_0[0], Verbose=False)
	agent_0.Plr.Map.ExitState = door_0[1]
	agent_0.Plr.Agent.ResampleAgent()
	agent_1.Plr.Prepare() # Maybe set "Validate=False"

	door_1 = random.choice(doors)
	agent_1.SetStartingPoint(door_1[0], Verbose=False)
	agent_1.Plr.Map.ExitState = door_1[1]
	agent_1.Plr.Agent.ResampleAgent()
	agent_1.Plr.Prepare() # Maybe set "Validate=False"

	results_one_agent[i] = scene_likelihood_one_agent(agents_0, observations, \
		num_paths)
	results_two_agents[i] = scene_likelihood_two_agents(agent_0, agent_1, \
		observations, num_paths)

# Debugging
TotalPlanDistribution = [0, 0, 0]
for i in range(Samples):
	TotalPlanDistribution = np.array(TotalPlanDistribution) + np.array(ResultsOneAgent[i][1])
print(TotalPlanDistribution)

TotalPlanDistribution = [0, 0, 0]
TotalRewardDistribution = [0, 0, 0]
for i in range(Samples):
	TotalPlanDistribution = np.array(TotalPlanDistribution) + np.array(ResultsTwoAgents[i][0][1])
	TotalRewardDistribution = np.array(TotalRewardDistribution) \
	+ (np.array(ResultsTwoAgents[i][0][0]) == np.max(np.array(ResultsTwoAgents[i][0][0]))) + 0.0
print("Plan distribution: " + str(TotalPlanDistribution))
print("Reward distribution: " + str(TotalRewardDistribution))

TotalPlanDistribution = [0, 0, 0]
TotalRewardDistribution = [0, 0, 0]
for i in range(Samples):
	TotalPlanDistribution = np.array(TotalPlanDistribution) + np.array(ResultsTwoAgents[i][1][1])
	TotalRewardDistribution = np.array(TotalRewardDistribution) \
	+ (np.array(ResultsTwoAgents[i][1][0]) == np.max(np.array(ResultsTwoAgents[i][1][0]))) + 0.0
print("Plan distribution: " + str(TotalPlanDistribution))
print("Reward distribution: " + str(TotalRewardDistribution))

##########
# Export #
##########

# Put the samples in a dictionary
ActionPosterior = {}
StatePosterior = {}
# for R in results[i]:
for R in ResultsOneAgent:
	# Second entry encodes entire likelihood of reward function.
	# So if reward function can't generate scene then don't bother.
	if R[2] != 0:
		# R[3] has a boolean vector of which samples match image
		for sampleno in range(len(R[3])):
			action = R[4].Actions[sampleno]
			states = R[4].States[sampleno]
			ImageMatch = False if R[3][sampleno] == 0 else True
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
InferredActions = [ActionPosterior.keys(), ActionPosterior.values()]
InferredActions[1] = [x/ca for x in InferredActions[1]]

cb = sum(StatePosterior.values())
InferredStates = [StatePosterior.keys(), StatePosterior.values()]
InferredStates[1] = [x/cb for x in InferredStates[1]]

# Save the state posterior as a csv so we can visualize them in R
# File = path + TrialName + "_States_Posterior_" + filenames[i] + ".csv"
File = path + TrialName + "_States_Posterior_" + "one_agent" + ".csv"
# File = path + TrialName + "_States_Posterior_" + "one_agent_C-only" + ".csv"
with open(File, "w") as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",", lineterminator="\n")
	try:
		ObservationLength = max([len(x) for x in InferredStates[0]]) # 
		model_writer.writerow(["MapHeight", "MapWidth", "Scene0", "Scene1", "Probability"] + 
		["Obs"+str(i) for i in range(ObservationLength)])
		for i in range(len(InferredStates[1])):
			model_writer.writerow(
				[
					Agents[0].Plr.Map.mapheight, 
					Agents[0].Plr.Map.mapwidth, 
					Scene[0],
					Scene[1],
					InferredStates[1][i]
				] 	
				+ list(InferredStates[0][i])
			)
	except:
		pass
	
###########################

ActionPosterior = {}
StatePosterior = {}
# for R in results[i]:
# print("====================================")
# print(np.shape(ResultsTwoAgents))
agent_0 = np.array(ResultsTwoAgents)[:, 0].tolist()
agent_1 = np.array(ResultsTwoAgents)[:, 1].tolist()
# print(np.shape(agent_0), np.shape(agent_1))
# print("====================================")
for s in range(Samples):
	# Second entry encodes entire likelihood of reward function.
	# So if reward function can't generate scene then don't bother.
	if agent_0[s][2] != 0:
		# R[3] has a boolean vector of which samples match image
		for sampleno in range(rollouts):
			action_0 = agent_0[s][4].Actions[sampleno]
			action_1 = agent_1[s][4].Actions[sampleno]
			states_0 = agent_0[s][4].States[sampleno]
			states_1 = agent_1[s][4].States[sampleno]
			ImageMatch = False if agent_0[s][3][sampleno] == 0.0 else True
			# If action will have probability zero because it never matched scene, then don't bother.
			if ImageMatch:
				key = tuple(action_0 + [-1] + action_1)
				if key in ActionPosterior:
					ActionPosterior[key] += agent_0[s][2]
				else:
					ActionPosterior[key] = agent_0[s][2]
				key = tuple(states_0 + [-1] + states_1)
				# print("=========== KEY ==============")
				# print(key)
				if key in StatePosterior:
					StatePosterior[key] += agent_0[s][2]
				else:
					StatePosterior[key] = agent_0[s][2]

# Remove dictionary ugliness and normalize
ca = sum(ActionPosterior.values())
InferredActions = [ActionPosterior.keys(), ActionPosterior.values()]
InferredActions[1] = [x/ca for x in InferredActions[1]]

cb = sum(StatePosterior.values())
InferredStates = [StatePosterior.keys(), StatePosterior.values()]
InferredStates[1] = [x/cb for x in InferredStates[1]]

# Save the state posterior as a csv so we can visualize them in R
File = path + TrialName + "_States_Posterior_" + "two_agents" + ".csv"
# File = path + TrialName + "_States_Posterior_" + "two_agents_C-only" + ".csv"
with open(File, "w") as model_inferences:
	model_writer = csv.writer(model_inferences, delimiter=",", lineterminator="\n")
	ObservationLength_0 = 0
	ObservationLength_1 = 0
	for i in range(len(InferredStates[0])):
		divider = np.argmax((np.array(InferredStates[0][i]) == -1) + 0.0)
		first_half = list(InferredStates[0][i][0:divider])
		second_half = list(InferredStates[0][i][divider+1:])
		if len(first_half) > ObservationLength_0:
			ObservationLength_0 = len(first_half)
		if len(second_half) > ObservationLength_1:
			ObservationLength_1 = len(second_half)
	model_writer.writerow(["MapHeight", "MapWidth", "Scene0", "Scene1", "Probability"] + 
		["Obs0_"+str(i) for i in range(ObservationLength_0)] + ["Obs1_"+str(i) for i in range(ObservationLength_1)])
	for i in range(len(InferredStates[0])):
		divider = np.argmax((np.array(InferredStates[0][i]) == -1) + 0.0)
		model_writer.writerow(
			[
				Agents[0].Plr.Map.mapheight, 
				Agents[0].Plr.Map.mapwidth, 
				Scene[0],
				Scene[1],
				InferredStates[1][i]
			]
			+ list(InferredStates[0][i][0:divider])
			+ ["NA" for j in range(ObservationLength_0-divider)]
			+ list(InferredStates[0][i][divider+1:])
		)

#############
# Normalize #
#############

# Compute the mean likelihood over sampled reward functions for one agent.
MeanLikelihoodOneAgent = np.mean([ResultsOneAgent[i][2] for i in range(np.shape(ResultsOneAgent)[0])])

# Compute the mean likelihood over sampled reward functions for two agents.
MeanLikelihoodTwoAgents = np.mean([ResultsTwoAgents[i][0][2] for i in range(np.shape(ResultsTwoAgents)[0])])

#############
# Posterior #
#############

# Compute the posterior using Bayes' theorem.
print(MeanLikelihoodOneAgent, MeanLikelihoodTwoAgents)
Posterior = MeanLikelihoodTwoAgents / (MeanLikelihoodOneAgent+MeanLikelihoodTwoAgents)

# Write the data to a file.
with open(path+world+".csv", "w") as file:
	writer = csv.writer(file)
	writer.writerow([world, MeanLikelihoodOneAgent, MeanLikelihoodTwoAgents, Posterior])