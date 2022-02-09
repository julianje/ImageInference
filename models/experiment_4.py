import csv

from Bishop import *

# Load the map we're simulating.
WORLD = sys.argv[1]

# Load the (encoded) coordinates of the door(s) and observation for this map.
ENCODED_DOORS = sys.argv[2]
ENCODED_OBSERVATION = sys.argv[3]

# Initialize the number of utility functions we want to sample.
NUM_SAMPLES = int(sys.argv[4])

# Initialize the prior type and distribution.
PRIOR_TYPE = sys.argv[5]
PRIOR_DISTRIBUTION = sys.argv[6]

# Initialize the number of paths we want to sample per utility function.
NUM_PATHS = 1000

# Set the stage of the path we're analyzing.
STAGE = "entering"

# Set the path for storing the model predictions.
PATH = "../data/experiment_4/model/predictions/Manhattan/"

# Compute the likelihood of the scene given possible paths, 
# p(s | t, g=g', d=d').
def scene_likelihood(agent, observation):
	# Generate paths according to the current map and policy.
	simulations = agent.SimulateAgents(NUM_PATHS, ResampleAgent=False, 
		Simple=False, Verbose=False, replan=False)

	# Check which paths contain the observation.
	scene_matches = np.zeros(NUM_PATHS)
	for i in range(len(simulations.States)):
		state_sequence = simulations.States[i]
		if STAGE == "entering":
			path = state_sequence[0:len(state_sequence)/2]
		elif STAGE == "exiting":
			path = state_sequence[len(state_sequence)/2:len(state_sequence)]
		elif STAGE == "either":
			path = state_sequence
		scene_matches[i] = (observation in path) * 1.0 / len(path)

	# Compute the scene likelihood.
	scene_likelihood = sum(scene_matches) * 1.0 / NUM_PATHS

	return [
		agent.Plr.GetPlanDistribution(),
		scene_likelihood,
		scene_matches,
		simulations
	]

# Transform x- and y-coordinates into a state representation.
def transform_state(agent, coords):
	return (coords[0]*agent.Plr.Map.mapwidth) + coords[1]

# Construct the prior distribution(s).
distribution_type = PRIOR_DISTRIBUTION.replace(" ", "")
if PRIOR_TYPE == "doors":
	# Initialize a pre-generated value mapping to transform the distribution
	# type to the actual (updated) prior distribution.
	value_mapping = {
		"two_doors": {
			"2": 0.204,
			"4": 0.442,
			"5": 0.558,
			"7": 0.796
		},
		"three_doors": {
			"1": 0.089,
			"2": 0.205,
			"3": 0.333,
			"6": 0.706
		}
	}

	# Compute the number of doors in the current map.
	num_doors = "two_doors" if ENCODED_DOORS.count("-")+1==2 \
		else "three_doors"

	# Construct the prior distribution using the value mapping.
	prior_distribution = [value_mapping[num_doors][d]
		for d in PRIOR_DISTRIBUTION.split(" ")]

	# Add a negligible offset to make the prior distribution valid in the
	# uniform case.
	prior_distribution[0] += 0.001 if distribution_type=="333" else 0
elif PRIOR_TYPE == "goals":
	# Read in samples from the (updated) prior distribution.
	with open(PATH+PRIOR_TYPE+"-"+distribution_type+".csv", "r") as file:
		reader = csv.reader(file)
		prior_distribution = []
		for row in reader:
			prior_distribution.append(np.array([int(num) for num in row]))
else:
	sys.exit("ERROR: Invalid PRIOR_TYPE defined.")

# Stitch the prior information together for saving the results.
prior_information = "_" + PRIOR_TYPE + "-" + distribution_type + "_"

# Create an agent for this map (while suppressing print output).
sys.stdout = open(os.devnull, "w")
agent = LoadObserver("../stimuli/experiment_1/"+WORLD, Silent=True)
sys.stdout = sys.__stdout__

# Decode the coordinates of the doors and the observation for this map.
doors = [[int(num) for num in pair.split(" ")]
	for pair in ENCODED_DOORS.split("-")]
observation = transform_state(agent,
	[int(num) for num in ENCODED_OBSERVATION.split(" ")])

# Sample utility functions and compute the likelihood of the scene given 
# a set of sampled paths.
print("Map: "+WORLD)
results = [0] * NUM_SAMPLES
for i in range(NUM_SAMPLES):
	# Let the user know which sample we're on.
	print("Utility function #"+str(i+1))

	# Sample which door the agent will use.
	door_prior = prior_distribution if PRIOR_TYPE == "doors" \
		else np.array([1.0/len(doors)]*len(doors))
	door = doors[np.random.choice(np.arange(len(doors)), p=door_prior)]
	agent.SetStartingPoint(door[0], Verbose=False)
	agent.Plr.Map.ExitState = door[1]

	# Run the planner for this agent (while supressing print output).
	sys.stdout = open(os.devnull, "w")
	agent.Plr.Prepare()
	sys.stdout = sys.__stdout__

	# Sample a utility function for the agent.
	agent.Plr.Utilities = prior_distribution[i] if PRIOR_TYPE == "goals" \
		else np.random.randint(100, size=len(agent.Plr.Map.ObjectNames))

	# Compute and store the likelihood of the scene given this utility
	# function.
	results[i] = scene_likelihood(agent, observation)

# Extract the posterior over states and actions (i.e., paths).
state_sequences = {}
action_sequences = {}
for result in results:
	# Execute if this utility function has some non-zero likelihood of 
	# generating the scene.
	if result[1] != 0:
		# Iterate through each path sampled using this utility function and 
		# check if it contained the observation.
		for i in range(NUM_PATHS):
			# If this path contained the observation, store its state and 
			# action sequence.
			if result[2][i] != 0:
				action_sequence = result[3].Actions[i]
				state_sequence = result[3].States[i]

				# If this state sequence is already stored, just add its
				# probability, p(s | t, g=g', d=d'). This term is multiplied 
				# by the frequency of the trajectory, which corresponds to
				# p(t | g=g', d=d').
				if tuple(state_sequence) in state_sequences:
					state_sequences[tuple(state_sequence)] += result[1]
				else:
					state_sequences[tuple(state_sequence)] = result[1]

				# If this action sequence is already stored, just add its
				# probability.
				if tuple(action_sequence) in action_sequences:
					action_sequences[tuple(action_sequence)] += result[1]
				else:
					action_sequences[tuple(action_sequence)] = result[1]

# Normalize the state sequences to generate the posterior over states.
states_posterior = [state_sequences.keys(), state_sequences.values()]
states_posterior[1] = [states_likelihood/sum(state_sequences.values())
	for states_likelihood in states_posterior[1]]

# Normalize the action sequences to generate the posterior over actions.
actions_posterior = [action_sequences.keys(), action_sequences.values()]
actions_posterior[1] = [actions_likelihood/sum(action_sequences.values())
	for actions_likelihood in actions_posterior[1]]

# Normalize the likelihood of the scene over the sampled doors and utility 
# functions.
results_norm = sum([results[i][1] for i in range(NUM_SAMPLES)])
if results_norm == 0:
	sys.exit("ERROR: No valid utility functions were sampled.")
else:
	for i in range(NUM_SAMPLES):
		results[i][1] /= results_norm

# Compute the probability of the agent pursuing each goal.
goal_probabilities = [0] * len(agent.Plr.Map.ObjectNames)
for g in range(len(agent.Plr.Map.ObjectLocations)):
	goal_probabilities[g] = sum([results[i][0][g]*results[i][1]
		for i in range(NUM_SAMPLES)])
goals_posterior = [agent.Plr.Map.ObjectNames, goal_probabilities]

# Store the posterior over states.
with open(PATH+WORLD+prior_information+"states_posterior.csv", "w") as file:
	# Compute the state sequence length of the longest path.
	max_state_sequence = max([len(state_sequence)
		for state_sequence in states_posterior[0]])

	# Write the data to a file.
	writer = csv.writer(file, delimiter=",", lineterminator="\n")
	writer.writerow(["map_height", "map_width", "observation",
		"probability"] + ["s_"+str(i) for i in range(max_state_sequence)])
	for i in range(len(states_posterior[0])):
		writer.writerow([
			agent.Plr.Map.mapheight,
			agent.Plr.Map.mapwidth,
			observation,
			states_posterior[1][i]
		]
		+ list(states_posterior[0][i]))

# Store the posterior over actions.
with open(PATH+WORLD+prior_information+"actions_posterior.csv", "w") as file:
	# Compute the action sequence length of the longest path.
	max_action_sequence = max_state_sequence - 1

	# Write the data to a file.
	writer = csv.writer(file, delimiter=",", lineterminator="\n")
	writer.writerow(["map_height", "map_width", "observation",
		"probability"] + ["a_"+str(i) for i in range(max_action_sequence)])
	for i in range(len(actions_posterior[0])):
		writer.writerow([
			agent.Plr.Map.mapheight,
			agent.Plr.Map.mapwidth,
			observation, 
			actions_posterior[1][i]
		]
		+ list(actions_posterior[0][i]))

# Store the posterior over goals.
with open(PATH+WORLD+prior_information+"goals_posterior.csv", "w") as file:
	# Write the data to a file.
	writer = csv.writer(file, delimiter=",", lineterminator="\n")
	writer.writerow(["goal", "probability"])
	for i in range(len(goals_posterior[0])):
		writer.writerow([goals_posterior[0][i], goals_posterior[1][i]])
