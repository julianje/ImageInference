import subprocess
import sys

if __name__ == "__main__":
	cluster = sys.argv[1]

	maps = [
		{"map": "DX_DX_0", "doors": "16 5-56 55", "observation": "6 4", "num_doors": 1},
		{"map": "DX_NX_0", "doors": "16 5-104 115", "observation": "5 4", "num_doors": 1},
		{"map": "DX_PX_0", "doors": "15 4-86 87", "observation": "3 6", "num_doors": 1},
		{"map": "DX_UN_0", "doors": "16 5-86 87", "observation": "7 6", "num_doors": 1},
		{"map": "ND_DX_0", "doors": "64 65", "observation": "4 4", "num_doors": 1},
		{"map": "ND_DX_1", "doors": "42 43", "observation": "2 6", "num_doors": 1},
		{"map": "ND_NX_0", "doors": "64 65", "observation": "5 4", "num_doors": 1},
		{"map": "ND_NX_1", "doors": "42 43", "observation": "3 7", "num_doors": 2},
		{"map": "ND_PX_0", "doors": "42 43", "observation": "3 5", "num_doors": 2},
		{"map": "ND_PX_1", "doors": "104 115", "observation": "3 3", "num_doors": 2},
		{"map": "ND_UN_0", "doors": "64 65", "observation": "5 6", "num_doors": 2},
		{"map": "NX_DX_0", "doors": "64 65-56 55-106 117", "observation": "6 5", "num_doors": 3},
		{"map": "NX_NX_0", "doors": "17 6-75 76-105 116", "observation": "5 4", "num_doors": 3},
		{"map": "NX_PX_0", "doors": "53 54-67 66-105 116", "observation": "3 7", "num_doors": 3},
		{"map": "NX_UN_0", "doors": "56 55-64 65-106 117", "observation": "4 7", "num_doors": 3},
		{"map": "PX_DX_0", "doors": "16 5-45 44-106 117", "observation": "6 2", "num_doors": 3},
		{"map": "PX_NX_0", "doors": "64 65-67 66-107 118", "observation": "4 6", "num_doors": 3},
		{"map": "PX_PX_0", "doors": "16 5-53 54-103 114", "observation": "5 5", "num_doors": 3},
		{"map": "PX_UN_0", "doors": "53 54-56 55-107 118", "observation": "4 7", "num_doors": 3},
		{"map": "UN_DX_0", "doors": "16 5-56 55", "observation": "6 5", "num_doors": 2},
		{"map": "UN_NX_0", "doors": "18 7-78 77", "observation": "7 7", "num_doors": 2},
		{"map": "UN_PX_0", "doors": "75 76-105 116", "observation": "5 3", "num_doors": 2},
		{"map": "UN_UN_0", "doors": "64 65-104 115", "observation": "5 5", "num_doors": 2}
	]

	for m in maps:
		if cluster == "true":
			print("python main.py %s '%s' '%s'" % (m["map"], m["doors"], m["observation"]))
		elif cluster == "false":
			subprocess.call('python main.py %s "%s" "%s"' % (m["map"], m["doors"], m["observation"]), shell=True)
		else:
			print("Please specify if this file is being run on the cluster (true/false).")