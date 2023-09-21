# Social inferences from physical evidence

Project repository for the paper, "Social inferences from physical evidence via Bayesian event reconstruction" ([link](https://psycnet.apa.org/doi/10.1037/xge0001182)).

## Repository structure

- `analysis`: Contains the R code to generate all results and figures reported in the paper (see our [OSF repository](https://osf.io/q3ct5/) for a slimmer version of this same code)
- `cluster`: Contains the terminal commands for generating the model predictions for each trial per experiment
- `data`: Contains the raw and processed participant data and model predictions
- `experiments`: Contains the web code for generating the experiments
- `models`: Contains the Python code for generating model predictions given model parameters
- `stimuli`: Contains the stimuli used in the experiments
- `utils`: Contains scripts for processing data and updating model parameters

## Setup

To run the analysis code, you will need R 4.1.2 (or higher) and R Markdown 2.11 (or higher). To run the model code, you will need any version of Python 3, pandas 1.4.0 (or higher), and [Bishop](https://github.com/julianje/Bishop). To run scripts that process data for both, you will need a terminal capable of using Bash.

## Generating data

`cluster` contains a text file for each experiment, each with the list of terminal commands for generating the model predictions for each trial for that experiment. These commands can be run independently and in parallel or (if you dare) sequentially.

### Data processing scripts

For Experiment 2 and Experiment 3, you will need to run a data processing script before you can run the analysis code on the newly generated model predictions (each script simply concatenates a bunch of individual data files). For Experiment 2, `combine_bayes_factors.sh` concatenates the individual Bayes factors into a single file. To do this, run the following command inside of a Bash terminal in the project root directory:

```
bash utils/combine_bayes_factors.sh data_1
```

For Experiment 3, `combine_posteriors.sh` similarly concatenates the individual posteriors into a single file. To do this, run the following command inside of a Bash terminal in the project root directory:

```
bash utils/combine_posteriors.sh
```
