from Bishop import *

import csv
import itertools as it
import matplotlib.pyplot as plt
import numpy as np
import sys

#############
# Functions #
#############

# Compute the state from the x- and y-coordinates.
def TranslateState(Agent, coords): return (coords[0])*Agent.Plr.Map.mapwidth+coords[1]

# Computes the scene likelihood, p(s | A=1), and returns an array of size: rollouts x 5.
def SceneLikelihoodOneAgent(Observer, Scene, rollouts=10000, verbose=True, Stage="Entering"):
	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	if Stage=="Entering":
		SceneMatches = np.zeros(rollouts)
		TotalProbability = 0
		for i in range(len(Simulations.States)):
			# Take the set intersection of the observations and this path.
			Intersection = set(Scene).intersection(set(Simulations.States[i][0:len(Simulations.States[i])/2]))

			# Check if the union of the set intersections is equal to the observations.
			if set(Intersection) == set(Scene):
				# SceneMatches[i] = True
				SceneMatches[i] = 0.5 * (len(Simulations.States[i])/2)
			else:
				# SceneMatches[i] = False
				SceneMatches[i] = 0
			TotalProbability += 0.5 * (len(Simulations.States[i])/2)
	else:
		sys.exit("Other stages not yet supported.")
	return([
		Observer.Plr.Agent.rewards, 
		Observer.Plr.GetPlanDistribution(), 
		sum(SceneMatches)*1.0/TotalProbability, 
		SceneMatches, 
		Simulations
	])

# Computes the scene likelihood, p(s | A=2) and return an array of size: rollouts x 2 x 5.
def SceneLikelihoodTwoAgents(Observer0, Observer1, Scene, rollouts=10000, verbose=True, Stage="Entering"):
	Simulations0 = Observer0.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	Simulations1 = Observer1.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	if Stage=="Entering":
		SceneMatches = np.zeros(rollouts)
		TotalProbability = 0
		for i in range(len(Simulations0.States)):
			# Take the set intersection of the observations and this path.
			Intersection0 = set(Scene).intersection(set(Simulations0.States[i][0:len(Simulations0.States[i])/2]))
			Intersection1 = set(Scene).intersection(set(Simulations1.States[i][0:len(Simulations1.States[i])/2]))

			# Check that the length of each result is equal to 1 (meaning every path crosses only 1 crumb).
			# if len(Intersection0) != 1 or len(Intersection1) != 1:
			# 	SceneMatches[i] = False

			# Check if the union of the set intersections is equal to the observations.
			if set(Intersection0).union(Intersection1) == set(Scene):
				# SceneMatches[i] = True
				SceneMatches[i] = 0.5 * 0.5 / (len(Simulations0.States[i])/2) / (len(Simulations1.States[i])/2)
			else:
				# SceneMatches[i] = False
				SceneMatches[i] = 0
			TotalProbability += 0.5 * 0.5 / (len(Simulations0.States[i])/2) / (len(Simulations1.States[i])/2)
	else:
		sys.exit("Other stages not yet supported.")
	return([
		[
			Observer0.Plr.Agent.rewards, 
			Observer0.Plr.GetPlanDistribution(), 
			sum(SceneMatches)*1.0/TotalProbability, 
			SceneMatches,
			Simulations0
		], 
		[
			Observer1.Plr.Agent.rewards, 
			Observer1.Plr.GetPlanDistribution(), 
			sum(SceneMatches)*1.0/TotalProbability, 
			SceneMatches, 
			Simulations1
		]
	])

##############
# Parameters #
##############

# Number of reward functions to sample.
Samples = 1000

# Number of paths to sample (per reward function).
rollouts = 1000

# Determine how much information we want to output.
verbose = False

# Set whether we are analyzing "entering" paths (entrance to goal), "leaving" paths (goal to entrance), or both.
Stage = "Entering"

# Set whether agents are allowed to move diagonally.
diagonal = False

# Set the path for saving data.
path = "data/experiment_3/model/predictions/" + ("diagonal/" if diagonal else "Manhattan/")

# Set whether we are using the cluster or not, then load the trial information.
TrialName = sys.argv[1]
World = sys.argv[1]
Doors = [[int(num) for num in pair.split(" ")] for pair in sys.argv[2].split("-")]
Observation = [[int(num) for num in pair.split(" ")] for pair in sys.argv[3].split("-")]

#########
# Model #
#########

Agents = [
	LoadObserver("stimuli/experiment_3/"+World, Silent=not verbose),
	LoadObserver("stimuli/experiment_3/"+World, Silent=not verbose)
]
Scene = [TranslateState(Agents[0], Obs) for Obs in Observation]
ResultsOneAgent = [-1] * Samples
ResultsTwoAgents = [-1] * Samples
Entrance = [-1] * Samples
for i in range(Samples):
	sys.stdout.write("Reward function #"+str(i+1)+"\n")
	States = random.choice(Doors)
	for Agent in Agents:
		Agent.SetStartingPoint(States[0], Verbose=False)
		Agent.Plr.Map.ExitState = States[1]
		Agent.Plr.Agent.ResampleAgent()
		# while np.argmax(Agent.Plr.Agent.rewards) != 2: # ONLY run this if fixing the reward at a specific value (this can potentially run forever...)
		# 	Agent.Plr.Agent.ResampleAgent()
		# Run the planner manually since SceneLikelihood has planning turned off on SimulateAgents.
		Agent.Plr.Prepare(Validate=False) # Don't check for inconsistencies in model so that code runs faster.
	ResultsOneAgent[i] = SceneLikelihoodOneAgent(Agents[0], Scene, rollouts, verbose, Stage=Stage)
	ResultsTwoAgents[i] = SceneLikelihoodTwoAgents(Agents[0], Agents[1], Scene, rollouts, verbose, Stage=Stage)
	Entrance[i] = States[0]

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
# with open(File, "w") as model_inferences:
# 	model_writer = csv.writer(model_inferences, delimiter=",", lineterminator="\n")
# 	ObservationLength = max([len(x) for x in InferredStates[0]])
# 	model_writer.writerow(["MapHeight", "MapWidth", "Scene0", "Scene1", "Probability"] + 
# 		["Obs"+str(i) for i in range(ObservationLength)])
# 	for i in range(len(InferredStates[1])):
# 		model_writer.writerow(
# 			[
# 				Agents[0].Plr.Map.mapheight, 
# 				Agents[0].Plr.Map.mapwidth, 
# 				Scene[0],
# 				Scene[1],
# 				InferredStates[1][i]
# 			] 	
# 			+ list(InferredStates[0][i])
# 		)

###########################

ActionPosterior_0 = {}
ActionPosterior_1 = {}
StatePosterior_0 = {}
StatePosterior_1 = {}
# for R in results[i]:
for s in range(Samples):
	agent_0 = np.array(ResultsTwoAgents)[:, 0].tolist()
	agent_1 = np.array(ResultsTwoAgents)[:, 1].tolist()
	# Second entry encodes entire likelihood of reward function.
	# So if reward function can't generate scene then don't bother.
	if agent_0[s][2] != 0:
		# R[3] has a boolean vector of which samples match image
		for sampleno in range(rollouts):
			action_0 = agent_0[s][4].Actions[sampleno]
			action_1 = agent_1[s][4].Actions[sampleno]
			states_0 = agent_0[s][4].States[sampleno]
			states_1 = agent_1[s][4].States[sampleno]
			ImageMatch = False if agent_0[s][3][sampleno] == 0 else True
			# If action will have probability zero because it never matched scene, then don't bother.
			if ImageMatch:
				# If action is already in dictionary just add the new probability.
				# if tuple(action) in ActionPosterior:
				# 	ActionPosterior[tuple(action)] += R[2] # Likelihood of reward function * likelihood of action generating scene
				# else:
				# 	ActionPosterior[tuple(action)] = R[2]
				# # Same for scenes
				# if tuple(states) in StatePosterior:
				# 	StatePosterior[tuple(states)] += R[2] # Likelihood of reward function * likelihood of action generating scene
				# else:
				# 	StatePosterior[tuple(states)] = R[2]
				key = tuple(action_0 + [-1] + action_1)
				if key in ActionPosterior:
					ActionPosterior[key] += agent_0[s][2]
				else:
					ActionPosterior[key] = agent_0[s][2]
				key = tuple(states_0 + [-1] + states_1)
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
# File = path + TrialName + "_States_Posterior_" + filenames[i] + ".csv"
File = path + TrialName + "_States_Posterior_" + "two_agents" + ".csv"
# File = path + TrialName + "_States_Posterior_" + "two_agents_C-only" + ".csv"
# with open(File, "w") as model_inferences:
# 	model_writer = csv.writer(model_inferences, delimiter=",", lineterminator="\n")
# 	ObservationLength_0 = 0
# 	ObservationLength_1 = 0
# 	for i in range(len(InferredStates[0])):
# 		divider = np.argmax((np.array(InferredStates[0][i]) == -1) + 0.0)
# 		first_half = list(InferredStates[0][i][0:divider])
# 		second_half = list(InferredStates[0][i][divider+1:])
# 		print(divider)
# 		print("First half: ", first_half)
# 		print("Second half: ", second_half)
# 		if len(first_half) > ObservationLength_0:
# 			ObservationLength_0 = len(first_half)
# 		if len(second_half) > ObservationLength_1:
# 			ObservationLength_1 = len(second_half)
# 	sys.exit()
# 	# ObservationLength = max([len(x) for x in InferredStates[0]])
# 	model_writer.writerow(["MapHeight", "MapWidth", "Scene0", "Scene1", "Probability"] + 
# 		["Obs0_"+str(i) for i in range(ObservationLength_0)] + ["Obs1_"+str(i) for i in range(ObservationLength_1)])
# 	for i in range(len(InferredStates[1])):
# 		divider = np.argmax((np.array(InferredStates[0][i]) == -1) + 0.0)
# 		model_writer.writerow(
# 			[
# 				Agents[0].Plr.Map.mapheight, 
# 				Agents[0].Plr.Map.mapwidth, 
# 				Scene[0],
# 				Scene[1],
# 				InferredStates[1][i]
# 			]
# 			+ list(InferredStates[0][i][0:divider])
# 			+ list(InferredStates[0][i][divider+1:])
# 		)


#############
# Normalize #
#############

# Compute the mean likelihood over sampled reward functions for one agent.
# RNormalizer = sum([ResultsOneAgent[i][2] for i in range(np.shape(ResultsOneAgent)[0])])
# for i in range(np.shape(ResultsOneAgent)[0]):
# 	ResultsOneAgent[i][2] /= RNormalizer

MeanLikelihoodOneAgent = np.mean([ResultsOneAgent[i][2] for i in range(np.shape(ResultsOneAgent)[0])])
# MeanLikelihoodOneAgentA = np.mean([ResultsOneAgent[i][2] for i in range(334)])
# MeanLikelihoodOneAgentB = np.mean([ResultsOneAgent[i][2] for i in range(334, 667)])
# MeanLikelihoodOneAgentC = np.mean([ResultsOneAgent[i][2] for i in range(667, 1000)])

# Compute the mean likelihood over sampled reward functions for two agents.
# RNormalizer = sum([ResultsTwoAgents[i][0][2] for i in range(np.shape(ResultsTwoAgents)[0])])
# for i in range(np.shape(ResultsTwoAgents)[0]):
# 	ResultsTwoAgents[i][0][2] /= RNormalizer

MeanLikelihoodTwoAgents = np.mean([ResultsTwoAgents[i][0][2] for i in range(np.shape(ResultsTwoAgents)[0])])
# MeanLikelihoodTwoAgentA = np.mean([ResultsTwoAgents[i][0][2] for i in range(334)])
# MeanLikelihoodTwoAgentB = np.mean([ResultsTwoAgents[i][0][2] for i in range(334, 667)])
# MeanLikelihoodTwoAgentC = np.mean([ResultsTwoAgents[i][0][2] for i in range(667, 1000)])

#############
# Posterior #
#############
print(MeanLikelihoodOneAgent, MeanLikelihoodTwoAgents)
# Compute the posterior using Bayes' theorem.
Posterior = MeanLikelihoodTwoAgents / (MeanLikelihoodOneAgent+MeanLikelihoodTwoAgents)
# PosteriorA = MeanLikelihoodTwoAgentsA / (MeanLikelihoodOneAgentA+MeanLikelihoodTwoAgentsA)
# PosteriorB = MeanLikelihoodTwoAgentsB / (MeanLikelihoodOneAgentB+MeanLikelihoodTwoAgentsB)
# PosteriorC = MeanLikelihoodTwoAgentsC / (MeanLikelihoodOneAgentC+MeanLikelihoodTwoAgentsC)

# Write the data to a file.
with open("data/experiment_3/model/predictions/Manhattan/"+TrialName+".csv", "w") as file:
# with open("data/experiment_3/model/predictions/Manhattan/"+TrialName+"_C-only.csv", "w") as file:
	writer = csv.writer(file)
	writer.writerow([TrialName, MeanLikelihoodOneAgent, MeanLikelihoodTwoAgents, Posterior])

# with open("data/experiment_3/model/predictions/"+TrialName+"_fixed-reward.csv", "w") as file:
# 	writer = csv.writer(file)
# 	writer.writerow([TrialName, MeanLikelihoodOneAgentA, MeanLikelihoodTwoAgentsA, PosteriorA])
# 	writer.writerow([TrialName, MeanLikelihoodOneAgentB, MeanLikelihoodTwoAgentsB, PosteriorB])
# 	writer.writerow([TrialName, MeanLikelihoodOneAgentC, MeanLikelihoodTwoAgentsC, PosteriorC])