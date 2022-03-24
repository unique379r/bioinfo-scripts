#!/bin/bash


# The MIT License (MIT)

# Copyright (c) 2022 GitHub, Inc. and contributors

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# Date of modification: March 24, 2022
# version: 0.1
# Copyright (c) 2022 Kesharwani RK
# Authors: 
# Kesharwani RK ; Email: bioinforupesh2009 DOT au AT gmail.com; rupesh DOT kesharwani AT bcm DOT edu
# Fritz Sedlazeck; Email: Fritz DOT Sedlazeck AT bcm DOT edu



#Inputs: command line arguments
bam_hg38="$1" 
bam_chm13="$2"
SampleName="$3"

print_USAGE()
{
	echo -e '\n'
	echo -e "USAGE: bash ./generateT2TCandidates.sh <genome mapped bam> <chm 13 mapped bam> <SampleName>\n"
}

if [[ $# -ne 3 ]]; then
	printf -- '\033[31mERROR: No argument supplied or missing some; please check your inputs \033[0m\n';
	print_USAGE
	exit 1;
fi


## samtools check
if which samtools >/dev/null; then
    echo -e ""
else
	echo -e '\n'
    printf -- '\033[33mWARNING: Please make sure samtools are globally set to your system \033[0m\n';
    exit 1;
fi


## file check
if [[ ! -f $bam_hg38 ]]; then
	printf -- '\033[31mERROR: hg38 bam does not exist \033[0m\n';
	print_USAGE
	exit 1;
fi

if [[ ! -f $bam_chm13 ]]; then
	printf -- '\033[31mERROR: chm13 bam does not exist \033[0m\n';
	print_USAGE
	exit 1;
fi

if [[ "$3" == "" ]]; then
    printf -- '\033[31mERROR: No argument supplied \033[0m\n';
	print_USAGE
	exit 1;
fi

((
printf -- '\033[37mProgram Running.. \033[0m\n';
echo -e "=================================================="
echo -e "Given Inputs..."
echo -e "First file (assuming grch38 mapping):" $bam_hg38
echo -e "Second file (assuming chm13 mapping):" $bam_chm13
echo -e "Sample Name:" $SampleName
echo -e "==================================================\n"

generateCandidatesT2T () {
	local myhg38_bam=$1
	local mychm13_bam=$2
	local filename=$3
	file38="$(basename $myhg38_bam .sort.bam)"
	file13="$(basename $mychm13_bam .sort.bam)"
	echo "#Getting unmapped reads from bam of hg38..."
	samtools view -f 4 $myhg38_bam | cut -f 1 > $file38"_unmapped.txt"
	echo "#Getting header from bam of chm13..."
	samtools view -H $mychm13_bam > $file13"_"$filename".candidatesT2T.sam"
	echo "#Matching hg38 unmapped reads to chm13 bam reads and merging them to chm13 header sam.."
	samtools view -F 4 $mychm13_bam | fgrep -f $file38"_unmapped.txt" >> $file13"_"$filename".candidatesT2T.sam"
	echo "#sam to bam of candidateT2T.."
	samtools view -hb $file13"_"$filename".candidatesT2T.sam" | samtools sort -o $file13"_"$filename".candidatesT2T.sort.bam"
	samtools index $file13"_"$filename".candidatesT2T.sort.bam"
	echo "#Removing temp files"
	rm -f  $file13"_"$filename".candidatesT2T.sam"
	#rm -f  $file38"_unmapped.txt"
	echo "#ALL DONE"
	if [[ -f $file13"_"$filename".candidatesT2T.sort.bam" ]]; then
		printf -- '\033[32mProgram Successfully Completed. \033[0m\n';
	else
		printf -- '\033[31mERROR \033[0m\n';
	fi
}

## Analysis

generateCandidatesT2T $bam_hg38 $bam_chm13 $SampleName

) 2>&1) | tee -a "$SampleName"_file.log
