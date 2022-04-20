#!/bin/sh

SAMPLES=$(<${1})
BAMDIR=${2}
BAM=${3}
OUT=${4}
CHROM=${5}
BINS=${6}
PROG=${7}
CUT=${8}
COLS=${9}
THREADS=${10}

echo "Welcome to DisCovQC!"
echo 

cd ${OUT}

# create markdown with header for table
	
echo -e "| | | | |\n|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|" >> DisCovPlot.All.md
echo -e "| | | | |\n|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|" >> DisCovPlotComp.All.md

echo "Starting mosdepth..."

mkdir ${OUT}Data
cd ${OUT}Data

# generate data and plots

for SAMPLE in ${SAMPLES}; do

        mosdepth -n -x -c ${CHROM} -b ${BINS} ${SAMPLE} ${BAMDIR}${SAMPLE}${BAM}.bam -t ${THREADS}
        
done

echo "Data generated!"
echo "Let's make some plots!"

# create 2 individual ggplots for each sample as png and html (4 files total) 
# saves plots into a grid

mkdir ${OUT}Data/HTMLs
mkdir ${OUT}Data/Images

Rscript ${PROG}DistributedCoverage-wBashArg.R ${1} ${BINS} ${CUT} ${COLS}

echo "Plots are done."
echo "Time to put it all together."
echo
echo "This might take a hot second..."
echo

cd ${OUT}Data/Images

# add individual plot images to markdown file

declare -a Issues=( DisCovPlot.*.png );

for((n=0;n<${#Issues[@]};n++)); do
        if (( $(($n % 4 )) == 3 )); 
                # Run every 4 entries
                then echo "![](${Issues[$n]})" >> DisCovPlot.All.md
                else echo -n "![](${Issues[$n]}) | " >> DisCovPlot.All.md
        fi
done

declare -a Issues=( DisCovPlotComp.*.png );

for((n=0;n<${#Issues[@]};n++)); do
        if (( $(($n % 4 )) == 3 )); 
                # Run every 4 entries
                then echo "<img src='${Issues[$n]}'/>" >> DisCovPlotComp.All.md
                else echo -n "<img src='${Issues[$n]}'/> | " >> DisCovPlotComp.All.md
        fi
done

# All done!

echo "Just kidding :D"
echo "It's super quick ;)"
echo
echo "Thanks for using DisCovQC"