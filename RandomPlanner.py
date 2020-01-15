from Bishop import Planner

class Planner(Planner.Planner):
    def __init__(self):
        pass
        
    def SimulatePathUntil(self, StartingPoint, StopStates, inputMDP, Limit=300, Simple=False):
        iterations = 0
        Actions = []
        if not isinstance(StopStates, list):
            StopStates = [StopStates]
        StateSequence = [StartingPoint]
        State = StartingPoint
        while State not in StopStates:
            # [State, NewAct] = inputMDP.Run(
            #     State, self.Agent.SoftmaxAction, Simple)
            [tempState, tempAct] = inputMDP.Run(
                State, self.Agent.SoftmaxAction, Simple)
            # This prevents duplicate states.
            if tempState in StateSequence:
                continue
            else:
                State = tempState
                NewAct = tempAct
            Actions.append(NewAct)
            StateSequence.append(State)
            iterations += 1
            # If it gets stuck (e.g., spiraling inwards) then just break.
            if (iterations > Limit):
                print("ERROR: Simulation exceeded timelimit. PLANNER-009")
                # return [Actions, StateSequence]
                return None
        return [Actions, StateSequence]

    def Simulate(self, Simple=True):
        """
        Simulate an agent until it reaches the exit state or time runs out.
        IMPORTANT: THIS FUNCTION SIMULATES THROUGH THE NAIVE UTILITY CALCULUS.
        SimulatePathUntil() USES LOCAL MDPS.
        Args:
            Simple (bool): When more than one action is highest value, take the first one?
        """
        if self.Utilities is None:
            print("ERROR: Missing utilities. PLANNER-006")
            return None
        if self.goalindices is None:
            print("ERROR: Missing goal space. PLANNER-007")
            return None
        if self.Agent.SoftmaxChoice:
            options = self.Utilities
            options = options - abs(max(options))
            try:
                options = [
                    math.exp(options[j] / self.Agent.choiceTau) for j in range(len(options))]
            except OverflowError:
                print("ERROR: Failed to softmax utility function. PLANNER-008")
                return None
            if sum(options) == 0:
                # If all utilities are equal
                if Simple:
                    choiceindex = 0
                else:
                    choiceindex = random.choice(range(len(options)))
            else:
                softutilities = [
                    options[j] / sum(options) for j in range(len(options))]
                ChoiceSample = random.uniform(0, 1)
                choiceindex = -1
                for j in range(len(softutilities)):
                    if ChoiceSample < softutilities[j]:
                        choiceindex = j
                        break
                    else:
                        ChoiceSample -= softutilities[j]
        else:
            choiceindex = self.Utilities.index(max(self.Utilities))
        planindices = [0] + [j + 1 for j in self.goalindices[choiceindex]] + \
            [len(self.CriticalStates) - 1]
        # Simulate each sub-plan
        Actions = []
        States = [self.CriticalStates[0]]
        for i in range(1, len(planindices)):
            # Use this policy on local MDP
            self.MDP.policy = self.Policies[planindices[i]]
            while temp is not None:
                print("Attempting to find path...")
                temp = self.SimulatePathUntil(
                    self.CriticalStates[planindices[i - 1]], self.CriticalStates[planindices[i]], self.MDP)
            [subA, subS] = temp
            # [subA, subS] = self.SimulatePathUntil(
            #     self.CriticalStates[planindices[i - 1]], self.CriticalStates[planindices[i]], self.MDP)
            Actions.extend(subA)
            States.extend(subS[1:])
        return [Actions, States]