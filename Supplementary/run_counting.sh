#!/bin/sh
#SBATCH -n 1	# run a single task 
#SBATCH -c 16	# require 4 cores per task
#SBATCH --mem=64000M	# memory allocation in MB
#SBATCH -t 0-16:00	# allow the job to run for a max of 30min
#SBATCH --mail-user=piyushnanda@g.harvard.edu

module load matlab/R2022b-fasrc01
module load gcc

matlab -nojvm -nosplash -nodesktop -r "cluster_count_boundary_cond('*.tif');exit"






