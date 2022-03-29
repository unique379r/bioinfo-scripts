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
gff_hg38="$1" 
gff_chm13="$2"
SampleName="$3"
BasicStats="$4"

print_USAGE()
{
	echo -e '\n'
	echo -e "USAGE: bash ./generateT2TCandidatesIsoforms_gff.sh <genomic hg38/hg37 gff> <chm 13 gff> <SampleName> <BasicStats (Yes/No [default])>\n"
}

if [[ $# -ne 4 ]]; then
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
if [[ ! -f $gff_hg38 ]]; then
	printf -- '\033[31mERROR: hg38 gff does not exist \033[0m\n';
	print_USAGE
	exit 1;
fi

if [[ ! -f $gff_chm13 ]]; then
	printf -- '\033[31mERROR: chm13 gff does not exist \033[0m\n';
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
echo -e "First file (assuming grch38 gff):" $gff_hg38
echo -e "Second file (assuming chm13 gff):" $gff_chm13
echo -e "Sample Name:" $SampleName
echo -e "==================================================\n"

generateCandidatesT2T () {
	local myhg38_gff=$1
	local mychm13_gff=$2
	local filename=$3
	local stats=$4
	echo -e "#Working for:" $filename
	file38="$(basename $myhg38_gff .gff)"
	file13="$(basename $mychm13_gff .gff)"
	echo "#Getting transcripts from gff of hg38..."
	awk '{print $10}' $myhg38_gff | sort -u > "$file38".iso
	echo "#Extracting transcripts from chm13 gff by discarding the isoform that matches to hg38 gff .."
	fgrep -vf "$file38".iso $mychm13_gff > "$file13".candidates.iso.gff
	if [[ -f "$file13".candidates.iso.gff ]]; then
		echo -e "#Extracting isoforms only for chrY specific.."
		awk '$1=="chrY"' "$file13".candidates.iso.gff > "$file13".chrY.candidates.iso.gff
		echo "#ALL DONE"
		#printf -- '\033[32mProgram Successfully Completed. \033[0m\n'
		rm -f "$file38".iso
		if [[ $stats == "yes" || $stats == "Yes" ]]; then
			echo -e "#Basic Stats.."
                	genomicgff=$(awk '$3=="transcript"' $myhg38_gff | sort -u | wc -l)
                	chmgff=$(awk '$3=="transcript"' $mychm13_gff | sort -u | wc -l)
                	total=$(awk '$3=="transcript"' "$file13".candidates.iso.gff | wc -l)
                	chrY=$(awk '$3=="transcript"' "$file13".chrY.candidates.iso.gff | wc -l)
                	echo -e "# of total unique transcripts found in genomic gff:" $genomicgff
                	echo -e "# of total unique transcripts found in chm13 gff:" $chmgff
                	echo -e "# of total transcripts found in chm13 gff only:" $total
                	echo -e "# of transcripts found only in chrY of chm13 gff:" $chrY
			printf -- '\033[32mProgram Successfully Completed. \033[0m\n'
		else
			printf -- '\033[32mProgram Successfully Completed. \033[0m\n'
		fi
	else
		printf -- '\033[31mERROR \033[0m\n';
		rm -f "$file38".iso 
		exit 1;
	fi
}

## Analysis

generateCandidatesT2T $gff_hg38 $gff_chm13 $SampleName $BasicStats

) 2>&1) | tee -a "$SampleName"_file.log

