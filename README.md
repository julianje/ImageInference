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

# TODO

- [ ] Generate diagonal predictions
- [ ] Design experiment_2
- [ ] Compute correlation between number of sampled paths required to achieve minimal model error and the error between participant data and model predictions
	- Make a histogram of samples/paths with positive probability (a bunch of paths with even prob. means more participant uncertainty)
- [ ] Fix/document correct answers in `experiment_1_utils.js`
- [ ] Fix `end.php`