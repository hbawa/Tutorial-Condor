#!/bin/zsh
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh --quiet
localSetupROOT
#source $AtlasSetup/scripts/asetup.sh 17.7.3,slc5,here
export X509_USER_PROXY=x509up_u55261
echo 'job:' $1, 'from:' $2
files=$(wc -l <inputFileLists)
echo 'input files:' $files
awk -v jo=$1 -v totaljobs=$2 -v len=$files 'BEGIN {slice = len/totaljobs; start = jo*slice; end = (jo+1)*slice;} NR > start && NR <= end {print}' inputFileLists > inputFileCurrentList
cat inputFileCurrentList
python slimming_d3pd.py --in=inputFileCurrentList --out=SkimmedAndSlimmedfiles_$1.root --tree=physics --var=branchesList --selection=file:cutCode
