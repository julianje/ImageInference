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

# Directory 

- `experiment_1`: joint inference of entrance and goal
- `experiment_2`: path reconstruction
- `experiment_3`: inferring number of agents in a room

# TO-DO

- [ ] Fix/document correct answers in `experiment_1_utils.js`
- [ ] Fix `end.php`
- [ ] Clean up OSF repository