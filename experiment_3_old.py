import csv
import itertools as it
import matplotlib.pyplot as plt
import numpy as np
import sys

from Bishop import *

# Compute the state from the x- and y-coordinates.
def TranslateState(Agent, coords): return (coords[0])*Agent.Plr.Map.mapwidth+coords[1]

# Computes the scene likelihood, p(s | A=1), and returns an array of size: rollouts x 5.
def SceneLikelihoodOneAgent(Observer, Scene, rollouts=10000, verbose=True, Stage="Entering"):
	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	if Stage=="Entering":
		# Generate paths for this agent.
		SceneMatches = np.zeros(rollouts)
		for i in range(len(Simulations.States)):
			# Take the set intersection of the observations and this path.
			Intersection = set(Scene).intersection(set(Simulations.States[i][0:len(Simulations.States[i])/2]))

			# Check if the union of the set intersections is equal to the observations.
			if Intersection == set(Scene):
				SceneMatches[i] = 1.0
			else:
				SceneMatches[i] = 0.0
	else:
		sys.exit("Other stages not yet supported.")
	return([
		Observer.Plr.Agent.rewards, 
		Observer.Plr.GetPlanDistribution(), 
		sum(SceneMatches)*1.0/rollouts, 
		SceneMatches, 
		Simulations
	])

# Computes the scene likelihood, p(s | A=2) and return an array of size: rollouts x 2 x 5.
def SceneLikelihoodTwoAgents(Observer0, Observer1, Scene, rollouts=10000, verbose=True, Stage="Entering"):
	Simulations0 = Observer0.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	Simulations1 = Observer1.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
	if Stage=="Entering":
		# Set up probabilities of cookies being dropped according to a Poisson distribution.
		# P_0 = 0.22
		# P_1 = 0.33
		# P_2 = 0.25

		# Generate paths for both agents independently.
		SceneMatches = np.zeros(rollouts)
		for i in range(len(Simulations0.States)):
			# Randomly resample one of the paths if they are the same.
			# counter = 0
			# if Simulations0.States[i] == Simulations1.States[i]:
			# 	counter += 1
			# 	SceneMatches[i] = 0.0
			
			# counter = 0
			# while Simulations0.States[i] == Simulations1.States[i]:
			# 	counter += 1
			# 	new_simulations = Observer1.SimulateAgents(1, ResampleAgent=False, Simple=False, Verbose=verbose, replan=False)
			# 	Simulations1.Actions[i] = new_simulations.Actions[0]
			# 	Simulations1.States[i] = new_simulations.States[0]
			# 	if counter > 10: 
			# 		print("This is taking a while...")
			# print(counter)

			# Take the set intersection of the observations and this pair of paths.
			Intersection0 = set(Scene).intersection(set(Simulations0.States[i][0:len(Simulations0.States[i])/2]))
			Intersection1 = set(Scene).intersection(set(Simulations1.States[i][0:len(Simulations1.States[i])/2]))

			# # Check if one path explains both observations while the other explains neither.
			# if (len(Intersection0) == 2 and len(Intersection1) == 0) \
			# 	or (len(Intersection0) == 0 and len(Intersection1) == 2):
			# 	SceneMatches[i] = P_0 * P_2

			# Check if each path explains exactly one of the observations.
			if (len(Intersection0) == 1 and len(Intersection1) == 1) \
				and Intersection0.union(Intersection1) == set(Scene):
				# SceneMatches[i] = P_1 * P_1
				SceneMatches[i] = 1.0
			else:
				SceneMatches[i] = 0.0
			# # Check if one path explains both observations and the other path explains only one.
			# elif (len(Intersection0) == 1 and len(Intersection1) == 2) \
			# 	or (len(Intersection0) == 2 and len(Intersection1) == 1):
			# 	SceneMatches[i] = (P_0*P_2) + (P_1*P_1)

			# # Check if both paths explain both observations.
			# elif Intersection0 == set(Scene) and Intersection1 == set(Scene):
			# 	SceneMatches[i] = (2*(P_0*P_2)) + (P_1*P_1)
			# else:
			# 	SceneMatches[i] = 0.0
	else:
		sys.exit("Other stages not yet supported.")
	return([
		[
			Observer0.Plr.Agent.rewards, 
			Observer0.Plr.GetPlanDistribution(), 
			sum(SceneMatches)*1.0/rollouts, 
			SceneMatches,
			Simulations0
		], 
		[
			Observer1.Plr.Agent.rewards, 
			Observer1.Plr.GetPlanDistribution(), 
			sum(SceneMatches)*1.0/rollouts, 
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
for i in range(Samples):
	sys.stdout.write("Reward function #"+str(i+1)+"\n")
	# Agents[0].SetStartingPoint(Doors[0][0], Verbose=False)
	# Agents[0].Plr.Map.ExitState = Doors[0][1]
	# Agents[1].SetStartingPoint(Doors[1][0], Verbose=False)
	# Agents[1].Plr.Map.ExitState = Doors[1][1]
	for Agent in Agents:
		States = random.choice(Doors)
		Agent.SetStartingPoint(States[0], Verbose=False)
		Agent.Plr.Map.ExitState = States[1]
		Agent.Plr.Agent.ResampleAgent()
		# while np.argmax(Agent.Plr.Agent.rewards) != 2: # ONLY run this if fixing the reward at a specific value (this can potentially run forever...)
		# 	Agent.Plr.Agent.ResampleAgent()
		# Run the planner manually since SceneLikelihood has planning turned off on SimulateAgents.
		Agent.Plr.Prepare(Validate=False) # Don't check for inconsistencies in model so that code runs faster.
	# Make sure the second agent doesn't go for the same object as the first agent.
	# Agents[1].Plr.Utilities[np.argmax(Agents[0].Plr.Utilities)] = 0.0
	# print(Agents[0].Plr.Utilities, Agents[1].Plr.Utilities)
	
	# Agents[0].Plr.Agent.rewards = [0.0, 0.0, 100.0]
	# Agents[1].Plr.Agent.rewards = [0.0, 100.0, 0.0]
	# Agents[0].Plr.Prepare(Validate=False)
	# Agents[1].Plr.Prepare(Validate=False)

	ResultsOneAgent[i] = SceneLikelihoodOneAgent(Agents[0], Scene, rollouts, verbose, Stage=Stage)
	ResultsTwoAgents[i] = SceneLikelihoodTwoAgents(Agents[0], Agents[1], Scene, rollouts, verbose, Stage=Stage)

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
with open(path+TrialName+".csv", "w") as file:
	writer = csv.writer(file)
	writer.writerow([TrialName, MeanLikelihoodOneAgent, MeanLikelihoodTwoAgents, Posterior])