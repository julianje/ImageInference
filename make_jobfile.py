import sys

# Initialize the experiment number.
EXPERIMENT = sys.argv[1]

# Initialize the number of samples.
NUM_SAMPLES = sys.argv[2]

# Initialize a list of dictionaries that links maps to their doors and 
# observations for the maps with one observation.
ONE_OBSERVATION_MAPS = [
	{"map": "DX_DX_0", "doors": "16 5-56 55", "observation": "6 4"},
	{"map": "DX_NX_0", "doors": "16 5-104 115", "observation": "5 4"},
	{"map": "DX_PX_0", "doors": "15 4-86 87", "observation": "4 6"},
	{"map": "DX_UN_0", "doors": "104 115-34 33", "observation": "5 5"},
	{"map": "ND_DX_0", "doors": "64 65", "observation": "4 4"},
	{"map": "ND_DX_1", "doors": "42 43", "observation": "2 6"},
	{"map": "ND_NX_0", "doors": "64 65", "observation": "5 4"},
	{"map": "ND_NX_1", "doors": "42 43", "observation": "3 7"},
	{"map": "ND_PX_0", "doors": "42 43", "observation": "3 5"},
	{"map": "ND_PX_1", "doors": "53 54", "observation": "2 4"},
	{"map": "ND_UN_0", "doors": "86 87", "observation": "7 6"},
	{"map": "NX_DX_0", "doors": "64 65-106 117-56 55", "observation": "6 5"},
	{"map": "NX_NX_0", "doors": "14 3-53 54-105 116", "observation": "5 5"},
	{"map": "NX_PX_0", "doors": "75 76-105 116-34 33", "observation": "5 3"},
	{"map": "NX_UN_0", "doors": "64 65-106 117-56 55", "observation": "4 7"},
	{"map": "PX_DX_0", "doors": "16 5-106 117-45 44", "observation": "6 2"},
	{"map": "PX_NX_0", "doors": "64 65-106 117-67 66", "observation": "4 7"},
	{"map": "PX_PX_0", "doors": "17 6-105 116-34 33", "observation": "4 4"},
	{"map": "PX_UN_0", "doors": "53 54-97 98-56 55", "observation": "6 7"},
	{"map": "UN_DX_0", "doors": "16 5-56 55", "observation": "6 5"},
	{"map": "UN_NX_0", "doors": "18 7-78 77", "observation": "7 7"},
	{"map": "UN_PX_0", "doors": "75 76-105 116", "observation": "5 3"},
	{"map": "UN_UN_0", "doors": "64 65-104 115", "observation": "5 5"}
]

# Initialize a list of dictionaries that links maps to their doors and 
# observations for the maps with two observations.
TWO_OBSERVATION_MAPS = [
	{"map": "D1_0", "doors": "64 65", "observation": "4 5-4 7"},
	{"map": "D1_1", "doors": "17 6", "observation": "3 6-5 4"},
	{"map": "D1_2", "doors": "56 55-64 65", "observation": "6 4-6 6"},
	{"map": "P1_0", "doors": "64 65", "observation": "4 4-5 6"},
	{"map": "P1_1", "doors": "64 65", "observation": "6 6-8 4"},
	{"map": "P1_2", "doors": "78 77-106 117", "observation": "4 8-6 7"},
	{"map": "UN_0", "doors": "104 115", "observation": "4 5-7 5"},
	{"map": "UN_1", "doors": "64 65", "observation": "4 5-5 7"},
	{"map": "UN_2", "doors": "53 54-103 114", "observation": "4 6-6 4"},
	{"map": "P2_0", "doors": "86 87", "observation": "5 5-7 5"},
	{"map": "P2_1", "doors": "106 117", "observation": "2 4-8 5"},
	{"map": "P2_2", "doors": "64 65-104 115", "observation": "4 6-6 6"},
	{"map": "D2_0", "doors": "64 65", "observation": "4 6-6 6"},
	{"map": "D2_1", "doors": "64 65", "observation": "4 8-6 5"},
	{"map": "D2_2", "doors": "16 5-56 55", "observation": "4 7-7 4"}
]

# Create the formatting strings and out them to stdout.
if EXPERIMENT == "1":
	for m in ONE_OBSERVATION_MAPS:
		print("python experiment_1.py %s '%s' '%s' %s" % \
			(m["map"], m["doors"], m["observation"], NUM_SAMPLES))
elif EXPERIMENT == "3":
	for m in TWO_OBSERVATION_MAPS:
		print("python experiment_3.py %s '%s' '%s' %s" % \
			(m["map"], m["doors"], m["observation"], NUM_SAMPLES))
elif EXPERIMENT == "error_analysis":
	for m in TWO_OBSERVATION_MAPS:
		for i in range(100):
			print("python error_analysis.py %s '%s' '%s' %s %s" % \
				(m["map"], m["doors"], m["observation"], NUM_SAMPLES, i))
else:
	sys.exit("Please enter a valid experiment.")
