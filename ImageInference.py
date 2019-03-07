from Bishop import *
import itertools as it
import sys
# ASSUMPTIONS:
# Agent is pursuing a single goal (is this true?)
# (x,y) state descriptions go left to right and top to bottom. Indexing starts at 1
# Prior over mental states is implicitly defined in the sampler (O.Plr.Agent.ResampleAgent())

# Get State id from x,y coordinates
def TranslateState(coords): return (coords[0]-1)*O.Plr.Map.mapwidth+coords[1]-1
# Test if scene is in an action rollout
def MatchState(Scene,States): return sum([Scene==States[x:(x+2)] for x in range(len(States)-2)])>0
# Get probability that agent generates scene
def SceneLikelihood(Observer, Scene, rollouts=10000, verbose=True):
	Simulations = Observer.SimulateAgents(rollouts, ResampleAgent=False, Simple=False, Verbose=verbose)
	return [Simulations, sum([MatchState(Scene,x) for x in Simulations.States])*1.0/rollouts]

##############
# Parameters #
##############
verbose = True
World = "RoomTest"
Observation = [[5,9],[4,8]] # These go forward in time
Samples = 5
rollouts=100

#############
# Run model #
#############
O = LoadObserver(World, Silent= not verbose)
Scene = [TranslateState(Observation[0]),TranslateState(Observation[1])]
Results = [0]*Samples
for i in range(Samples):
	sys.stdout.write("Agent "+str(i)+"\n")
	O.Plr.Agent.ResampleAgent()
	Results[i] = SceneLikelihood(O, Scene, rollouts, verbose)

###########################
# Compute state posterior #
###########################
Warn = True
Posterior = {}
for sample in Results:
	if sample[1] != 0:
		Warn = False
		for trace in sample[0].Actions:
			p = sample[1]*1.0/rollouts
			if tuple(trace) in Posterior:
				Posterior[tuple(trace)] += p
			else:
				Posterior[tuple(trace)] = p
if Warn:
	sys.stdout.write("Couldn't find parameters that render scene.")
# Normalize
c = sum(Posterior.values())
Posterior = [Posterior.keys(),Posterior.values()]
Posterior[1] = [x/c for x in Posterior[1]]
# Print best path
MAP = Posterior[0][Posterior[1].index(max(Posterior[1]))]
O.DrawMap(World+str(Observation)+".png",MAP)
