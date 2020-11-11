# run_ANIcalculator.pl

A perl script to automate submission of genomes to ANIcalculator (2014-127) version 1.0.  
By specifying two separate groups of genomes, the script will automate submission of all GroupA vs GroupB pairwise genome comparisons to ANIcalculator and consolidate the results into a single output file.

## Additional Software Requirement:
- Program binary for ANIcalculator (2014-127) version 1.0 (available at https://ani.jgi.doe.gov/)  

## Input:
- A configuration file specifying the parameter settings for the script. See config_example.txt for file format and additional instructions and parameter definitions.  
- A directory containing genome fasta files.  

## Output:
- A text file (filename to be specified in configuration file) compiling ANIcalculator results for all comparisons that were run. 

## Usage:
`perl run_ANIcalculator.pl config_example.txt`
