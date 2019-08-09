import subprocess
import sys

if __name__ == "__main__":
	cluster = sys.argv[1]

	maps = [
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

	for m in maps:
		if cluster == "true":
			print("python main.py %s '%s' '%s'" % (m["map"], m["doors"], m["observation"]))
		elif cluster == "false":
			subprocess.call('python main.py %s "%s" "%s"' % (m["map"], m["doors"], m["observation"]), shell=True)
		else:
			print("Please specify if this file is being run on the cluster (true/false).")