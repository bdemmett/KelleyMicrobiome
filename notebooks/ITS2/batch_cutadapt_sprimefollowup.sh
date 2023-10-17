#!/bin/bash

# job standard output will go to the file slurm-%j.out (where %j is the job ID)

#SBATCH --time=6:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=2   # 1 processor core(s) per node X 2 threads per core
#SBATCH --mem=6G   # maximum memory per node
#SBATCH --partition=short    # standard node(s)
#SBATCH --job-name="cutadapt2"
#SBATCH --mail-user=bryan.emmett@usda.gov   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
############### user inputs

# specify paths of input and output folders
dir='/project/mmicrobe/Kelley/ITS2/Raw/KY21-1-2'

filtdir='cutadapt'
filtdir="$dir/$filtdir"

outdir='cutadapt2'
outdir="$dir/$outdir"

unTdir="untrimmed"
dir3="$dir/$unTdir"

# Specify primer sequences

FWD="TCTTTCCCTACACGACGCTCTTCCGATCT"
REV="GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT"
FWDrc="AGATCGGAAGAGCGTCGTGTAGGGAAAGA"
REVrc="AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"

##################

module load cutadapt

# Check for output directory and if not present, make directory

if [ ! -d $outdir ]; then
  mkdir -p $outdir;
fi

if [ ! -d $dir3 ]; then
  mkdir -p $dir3;
fi


# for loop to find all files with R1 in name, change their name to R2 and write out new filename to a new file in a new directory

for r1 in $filtdir/*_R1_*; do

r2=${r1/_R1_/_R2_}

baseR1=${r1##*/}
baseR2=${r2##*/}


fnFsCut="$outdir/$baseR1"
fnRsCut="$outdir/$baseR2"
untrimmedF="$dir3/untrimmed.$baseR1"
untrimmedR="$dir3/untrimmed.$baseR2"


#echo $baseR2
#echo $dir3
#echo  $untrimmedR

cutadapt -g $FWD \
	-a $REVrc \
	-G $REV \
	-A $FWDrc \
	-n 2 \
	-m 50 \
	-o $fnFsCut \
	-p $fnRsCut \
	$r1 \
	$r2
done
