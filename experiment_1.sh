#!/bin/bash

#SBATCH --output dsq-jobs-%A_%1a-%N.out
#SBATCH --array 0-22
#SBATCH --job-name experiment_1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=michael.lopez-brau@yale.edu
#SBATCH -t 1-

# Load Python environment.
source activate /gpfs/loomis/project/fas/jara-ettinger/mal237/conda_envs/py27 

# DO NOT EDIT LINE BELOW
/gpfs/loomis/apps/avx/software/dSQ/0.96/dSQBatch.py /gpfs/loomis/project/jara-ettinger/mal237/ImageInference/experiment_1.txt /gpfs/loomis/project/jara-ettinger/mal237/ImageInference

