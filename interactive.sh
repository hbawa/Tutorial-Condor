#!/bin/zsh
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh 
asetup 17.2.7,single,here,slc5
which athena
localSetupFAX
voms-proxy-init -valid 24:0 -voms atlas
echo 'job:' $1, 'from:' $2
files=$(wc -l <inputFileListLarge)
echo 'input files:' $files
awk -v jo=$1 -v totjobs=$2 -v len=$files 'BEGIN {slice = len/totjobs; start = jo*slice; end = (jo+1)*slice;} NR > start && NR <= end {print}' inputFileListLarge > inputFileList
more inputFileList
python filter-and-merge-d3pd.py  --in=inputFileList --out=SkimmedSlimmed_$1.root --tree=physics --var=branchesList --selection=file:cutCode
