#!/bin/bash 
# Read a .MS0 file and extract data to SPECTRA directory.
# Argument list: 
#   $1 = MS0 file
# Output files:
#   .sxt --> Spectrum data
#   .txt --> Spectrum data file without 0.0 0.0

sxt_file=`echo ${1} | sed 's/MS0/sxt/'`
txt_file="$(echo ${1} | sed 's/\.MS0/_experimental\.txt/')"
#echo ${sxt_file};
#echo ${txt_file};

if [ ! -d SPECTRA ]
then
  mkdir SPECTRA
fi

spec_read.rb ${1} ${sxt_file}
if [ -e ${txt_file} ]; then  rm ${txt_file}; fi  
touch ${txt_file}
cat ${sxt_file} | grep -v '0.0 0.0' >> ${txt_file}
mv ${sxt_file} SPECTRA/;
mv ${txt_file} SPECTRA/;
