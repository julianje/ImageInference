# Model formulation

```
P(actions | scene) = sum(P(actions, rewards | scene)) = sum(P(actions | rewards, scene) * P(rewards))
```

# Model assumptions

- Agent can only move horizontal/vertical, but not diagonal
- Agent cannot move through gray walls
- Agent is always going for one and only one object
- Agent is always in pursuit of one object
- Agent leaves the room in the same door they come in

# To-do

- [ ] Finish generating diagonal predictions:
	- [ ] `ND_NX_0`
	- [ ] `UN_NX_0`
	- [ ] `UN_UN_0`
- [X] Redesign stimuli and/or update introduction to better demonstrate the paths agents can take:
	- [X] `ND_DX_1`: People making unexpected inference
	- [X] `ND_PX_0`: Model making wrong prediction
	- [X] `NX_PX_0`: Not sure what's right or wrong here, might need to redesign
	- [X] `UN_NX_0`: Model making wrong prediction
- [X] Put up pilot_1
- [X] Analyze pilot_1 results
- [ ] Re-run pilot_1 (pilot_2)
- [ ] Analyze pilot_1 results
- [ ] Write up pre-registration
- [ ] Run experiment_1
- [ ] Analyze experiment_1 results
- [ ] Design experiment_2

- Compute correlation between number of model samples for minimal error and error between participant data and model predictions
	- Make a histogram of samples/paths with positive probability (a bunch of paths with even prob. means more participant uncertainty)