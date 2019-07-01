# Model assumptions

- Agent can only move horizontal/vertical, but not diagonal
- Agent cannot move through gray walls
- Agent is always going for one and only one object
- Agent is always in pursuit of one object
- Agent leaves the room in the same door they come in

P(actions | scene) = sum(P(actions, rewards | scene)) = sum(P(actions | rewards, scene) * P(rewards))

# To-do

- [ ] Finish generating diagonal predictions:
	- [ ] `ND_NX_0`
	- [ ] `UN_NX_0`
	- [ ] `UN_UN_0`
- [ ] Redesign stimuli and/or update introduction to better demonstrate the paths agents can take:
	- [ ] `ND_DX_1`: People making unexpected inference
	- [ ] `ND_PX_0`: Model making wrong prediction
	- [ ] `NX_PX_0`: Not sure what's right or wrong here, might need to redesign
	- [ ] `UN_NX_0`: Model making wrong prediction
- [ ] Put up pilot_1
- [ ] Design experiment_2