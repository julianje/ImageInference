# Social inferences from physical evidence

Project repository for the paper, "Social inferences from physical evidence via Bayesian event reconstruction" ([link](https://psycnet.apa.org/doi/10.1037/xge0001182)).

## Repository structure

- *analysis*: Contains the R code to generate all results and figures reported in the paper (see our [OSF repository](https://osf.io/q3ct5/) for a more slim version of this same code)
- *cluster*: Contains the terminal commands for generating the model predictions for each trial per experiment
- *data*: Contains the raw and preprocessed participant data and model predictions
- *experiments*: Contains the web code for generating the experiments
- *models*: Contains the Python code for generating model predictions given some model parameters
- *stimuli*: Contains the stimuli used in the experiments
- *utils*: Contains miscellaneous scripts for preprocessing data and updating model parameters

## Setup

To get started, you will need Python 3 and [Bishop](https://github.com/julianje/Bishop).

## Generating data

`cluster` contains a text file for each experiment, each with the list of terminal commands for generating the model predictions for each trial for that experiment. These commands can be run independently and in parallel or (if you dare) sequentially.
