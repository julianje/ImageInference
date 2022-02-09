import csv
import numpy as np

# Set up the path to the experiment.
PATH = "../experiments/experiment_4/"

# Function for creating a 4x4 tile of priors.
def make_tile(priors):
    return np.array([
        priors,
        np.roll(priors, 1),
        np.roll(priors, 2),
        np.roll(priors, 3)
    ])

# Set the seed.
np.random.seed(0)

# Define the types of prior distributions.
goal_priors = ["333", "621", "162", "216"]
door_priors = {
    "two_doors": ["54", "72", "27", "54"],
    "three_doors": ["333", "621", "162", "216"]
}

# Set the number of participants.
num_participants = 160

# Set the number of trials.
num_trials = 16

# Set up an array for storing prior assignments.
prior_assignment = np.zeros([num_participants, num_trials+1], dtype=object)

# Populate the array in a "tiling" fashion.
num_tiles = (num_participants/4)*(num_trials/4)
half_tiles = num_tiles / 2
for t in np.arange(num_tiles):
    if t < half_tiles:
        # Set up a tile matrix over possible goal priors.
        tile = make_tile(goal_priors)

        # Insert the tile matrix into the prior assignment array.
        rows = [int(0+4*(t//2)), int(4+4*(t//2))]
        cols = [int(0+4*(t%2)), int(4+4*(t%2))]
        prior_assignment[rows[0]:rows[1], cols[0]:cols[1]] = tile
    elif t >= half_tiles:
        # # Set up a tile matrix over possible door priors.
        tile = make_tile(door_priors["two_doors"])

        # Shuffle the tile matrix and insert it into the prior assignment
        # array.
        rows = [int(0+4*((t-half_tiles)//2)), int(4+4*((t-half_tiles)//2))]
        prior_assignment[rows[0]:rows[1], 12:16] = tile

        # Set up a tile matrix over possible door priors.
        tile = make_tile(door_priors["three_doors"])

        # Shuffle the tile matrix and insert it into the prior assignment
        # array.
        prior_assignment[rows[0]:rows[1], 8:12] = tile

# Add the experiment block order.
prior_assignment[0:num_participants//2, num_trials] = "0"
prior_assignment[num_participants//2:num_participants, num_trials] = "1"

# Print to a file.
with open(PATH+"condition_assignment.csv", "w") as file:
    writer = csv.writer(file, delimiter=",", lineterminator="\n")
    for row in prior_assignment:
        writer.writerow(row)
