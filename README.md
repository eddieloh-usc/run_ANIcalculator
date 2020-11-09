# run_ANIcalculator.pl

A perl script to automate submission of genomes to ANIcalculator.

## Additional Software Requirement:
- Program binary for ANIcalculator (TODO: include citation and link)  

## Input:
- A configuration file specifying the parameter settings for the script. See config_example.txt for file format and additional instructions and parameter definitions.  
- A directory containing genome fasta files.  

## Output:
- A text file (filename to be specified in configuration file) compiling ANIcalculator results for all comparisons that were run. 

## Usage:
perl run_ANIcalculator.pl config_example.txt
