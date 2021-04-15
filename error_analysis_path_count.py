import csv
import sys

from Bishop import *

# Load the map we're simulating.
WORLD = sys.argv[1]

# Load the (encoded) coordinates of the door(s) and observation for this map.
ENCODED_DOORS = sys.argv[2]
ENCODED_OBSERVATIONS = sys.argv[3]

# Initialize the number of utility functions we want to sample.
NUM_SAMPLES = int(sys.argv[4])

# Initialize the number of paths we want to sample per utility function.
NUM_PATHS = 1000

# Initialize the iteration of the current world.
WORLD_NUM = sys.argv[5]

# Set the stage of the path we're analyzing.
STAGE = "entering"

# Set the path for storing the model predictions.
PATH = "data/experiment_3/model/predictions/Manhattan/" \
	+ "error_analysis_num_unique_paths/" + WORLD_NUM + "/"

# Computes the likelihood that one agent was in the room based on the 
# observations. 
def scene_likelihood_one_agent(agent_0, observations):
	# Generate paths according to the current map and policy.
	simulations_0 = agent_0.SimulateAgents(NUM_PATHS, ResampleAgent=False, 
		Simple=False, Verbose=False, replan=False)

	# Iterate through each path and check if it's consistent with the 
	# observations.
	for i in range(len(simulations_0.States)):
		# Extract the subset of the path we're analyzing based on the stage.
		state_sequence_0 = simulations_0.States[i]
		if STAGE == "entering":
			path_0 = state_sequence_0[0:len(state_sequence_0)/2]
		elif STAGE == "exiting":
			path_0 = state_sequence_0[len(state_sequence_0)/2: \
				len(state_sequence_0)]
		elif STAGE == "either":
			path_0 = state_sequence_0

		# Take the set intersection of the observations and this path.
		intersection_0 = set(observations).intersection(set(path_0))

		# If this path explains the observations and is a unique path, store 
		# it.
		if intersection_0 == set(observations) \
				and str(path_0) not in unique_paths_one_agent:
			unique_paths_one_agent.append(str(path_0))

# Computes the likelihood that two agents were in the room based on the 
# observations.
def scene_likelihood_two_agents(agent_1, agent_2, observations):
	# Generate paths according to the current map and policy.
	simulations_1 = agent_1.SimulateAgents(NUM_PATHS, ResampleAgent=False, \
		Simple=False, Verbose=False, replan=False)
	simulations_2 = agent_2.SimulateAgents(NUM_PATHS, ResampleAgent=False, \
		Simple=False, Verbose=False, replan=False)

	# Iterate through each pair of paths and check if they're consistent with 
	# the observations.
	for i in range(len(simulations_1.States)):
		# Extract the subset of the path we're analyzing based on the stage.
		state_sequence_1 = simulations_1.States[i]
		state_sequence_2 = simulations_2.States[i]
		if STAGE == "entering":
			path_1 = state_sequence_1[0:len(state_sequence_1)/2]
			path_2 = state_sequence_2[0:len(state_sequence_2)/2]
		elif STAGE == "exiting":
			path_1 = state_sequence_1[len(state_sequence_1)/2: \
				len(state_sequence_1)]
			path_2 = state_sequence_2[len(state_sequence_2)/2: \
				len(state_sequence_2)]
		elif STAGE == "either":
			path_1 = state_sequence_1
			path_2 = state_sequence_2

		# Check that the paths are unique.
		if path_1 == path_2:
			continue

		# Take the set intersection of the observations and both paths.
		intersection_1 = set(observations).intersection(set(path_1))
		intersection_2 = set(observations).intersection(set(path_2))

		# Check that each path contains at least one of the observations, and
		# that the union of both paths contains both of the observations. If
		# the path pair is unique, store it.
		if (len(intersection_1) > 0 and len(intersection_2) > 0) \
				and intersection_1.union(intersection_2) == set(observations):
			path_pair = set([str(path_1), str(path_2)])
			if path_pair not in unique_paths_two_agents:
				unique_paths_two_agents.append(path_pair)

# Transform x- and y-coordinates into a state representation.
def transform_state(agent, coords):
	return (coords[0]*agent.Plr.Map.mapwidth) + coords[1]

# Create three agents for this map (while suppressing print output).
sys.stdout = open(os.devnull, "w")
agent_0 = LoadObserver("stimuli/experiment_3/"+WORLD, Silent=True)
agent_1 = LoadObserver("stimuli/experiment_3/"+WORLD, Silent=True)
agent_2 = LoadObserver("stimuli/experiment_3/"+WORLD, Silent=True)
sys.stdout = sys.__stdout__

# Decode the coordinates of the doors and the observation for this map.
doors = [[int(num) for num in pair.split(" ")] \
	for pair in ENCODED_DOORS.split("-")]
observations = [transform_state(agent_0, \
	[int(num) for num in pair.split(" ")]) \
	for pair in ENCODED_OBSERVATIONS.split("-")]

# Sample utility functions and compute the likelihood of the scene given 
# a set of sampled paths.
print("Map: "+WORLD)
unique_paths_one_agent = []
unique_paths_two_agents = []
for i in range(NUM_SAMPLES):
	# Let the user know which sample we're on.
	print("Utility function #: "+str(i+1))

	# Sample which door each agent will use.
	door_0 = random.choice(doors)
	door_1 = random.choice(doors)
	door_2 = random.choice(doors)
	agent_0.SetStartingPoint(door_0[0], Verbose=False)
	agent_1.SetStartingPoint(door_1[0], Verbose=False)
	agent_2.SetStartingPoint(door_2[0], Verbose=False)
	agent_0.Plr.Map.ExitState = door_0[1]
	agent_1.Plr.Map.ExitState = door_1[1]
	agent_2.Plr.Map.ExitState = door_2[1]

	# Run the planner for each agent (while supressing print output).
	sys.stdout = open(os.devnull, "w")
	agent_0.Plr.Prepare()
	agent_1.Plr.Prepare()
	agent_2.Plr.Prepare()
	sys.stdout = sys.__stdout__

	# Randomly sample utility functions (instead of reward functions) so that 
	# agents aren't influenced by how far the goals are.
	agent_0.Plr.Utilities = np.array([random.random()*100 \
		for goal in agent_0.Plr.Map.ObjectNames])
	agent_1.Plr.Utilities = np.array([random.random()*100 \
		for goal in agent_1.Plr.Map.ObjectNames])
	agent_2.Plr.Utilities = np.array([random.random()*100 \
		for goal in agent_2.Plr.Map.ObjectNames])

	# Compute the likelihood of the observations if one or two agents were in 
	# the room.
	scene_likelihood_one_agent(agent_0, observations)
	scene_likelihood_two_agents(agent_1, agent_2, observations)

# Open a file for writing the data.
with open(PATH+WORLD+"_num_unique_paths.csv", "w") as file:
	writer = csv.writer(file)

	# Compute the number of unique paths for one and two agents.
	num_unique_paths_one_agent = len(unique_paths_one_agent)
	num_unique_paths_two_agents = len(unique_paths_two_agents)

	# Write the data to a file.
	writer.writerow([WORLD, num_unique_paths_one_agent, \
		num_unique_paths_two_agents])