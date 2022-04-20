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

# calculate number of samples

N=$(wc -l < ${1})

cd ${OUT}Data/Images

# make HTML header for file with comparable plots grid

echo '<!DOCTYPE html>' >> ${OUT}DisCovPlotComp.All.html
echo '<html>' >> ${OUT}DisCovPlotComp.All.html
echo '<body>' >> ${OUT}DisCovPlotComp.All.html
echo '<style>' >> ${OUT}DisCovPlotComp.All.html
echo 'h2 {text-align: center;}' >> ${OUT}DisCovPlotComp.All.html
echo 'h3 {text-align: center;}' >> ${OUT}DisCovPlotComp.All.html
echo 'h4 {text-align: center;}' >> ${OUT}DisCovPlotComp.All.html
echo '</style>' >> ${OUT}DisCovPlotComp.All.html
echo '' >> ${OUT}DisCovPlotComp.All.html
echo '<h2>Distributed Coverage</h2>' >> ${OUT}DisCovPlotComp.All.html
echo '<h4><i>DisCovQC Output</i></h4>' >> ${OUT}DisCovPlotComp.All.html
echo "<h3><b>N=${N}</b></h3>" >> ${OUT}DisCovPlotComp.All.html
echo '<table>' >> ${OUT}DisCovPlotComp.All.html
echo '<tbody>' >> ${OUT}DisCovPlotComp.All.html
echo '<tr>' >> ${OUT}DisCovPlotComp.All.html

# add grids

declare -a Issues=( DisCovPlotComp.*.png );

for((n=0;n<${#Issues[@]};n++)); do
        if (( $(($n % $COLS )) == $(($COLS-1)) )); 
                # Run every 4 entries
                then echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>\n</tr>\n<tr>" >> ${OUT}DisCovPlotComp.All.html
                else echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>" >> ${OUT}DisCovPlotComp.All.html
        fi
done

echo '</tr>' >> ${OUT}DisCovPlotComp.All.html
echo '</body>' >> ${OUT}DisCovPlotComp.All.html
echo '</html>' >> ${OUT}DisCovPlotComp.All.html

# make HTML header for file with individual plots grid

echo '<!DOCTYPE html>' >> ${OUT}DisCovPlot.All.html
echo '<html>' >> ${OUT}DisCovPlot.All.html
echo '<body>' >> ${OUT}DisCovPlot.All.html
echo '<style>' >> ${OUT}DisCovPlot.All.html
echo 'h2 {text-align: center;}' >> ${OUT}DisCovPlot.All.html
echo 'h3 {text-align: center;}' >> ${OUT}DisCovPlot.All.html
echo 'h4 {text-align: center;}' >> ${OUT}DisCovPlot.All.html
echo '</style>' >> ${OUT}DisCovPlot.All.html
echo '' >> ${OUT}DisCovPlot.All.html
echo '<h2>Distributed Coverage</h2>' >> ${OUT}DisCovPlot.All.html
echo '<h4><i>DisCovQC Output</i></h4>' >> ${OUT}DisCovPlot.All.html
echo "<h3><b>N=${N}</b></h3>" >> ${OUT}DisCovPlot.All.html
echo '<table>' >> ${OUT}DisCovPlot.All.html
echo '<tbody>' >> ${OUT}DisCovPlot.All.html
echo '<tr>' >> ${OUT}DisCovPlot.All.html

# add grids

declare -a Issues=( DisCovPlot.*.png );

for((n=0;n<${#Issues[@]};n++)); do
        if (( $(($n % $COLS )) == $(($COLS-1)) )); 
                # Run every 4 entries
                then echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>\n</tr>\n<tr>" >> ${OUT}DisCovPlot.All.html
                else echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>" >> ${OUT}DisCovPlot.All.html
        fi
done

echo '</tr>' >> ${OUT}DisCovPlot.All.html
echo '</body>' >> ${OUT}DisCovPlot.All.html
echo '</html>' >> ${OUT}DisCovPlot.All.html

# All done!

echo "Just kidding :D"
echo "It's super quick ;)"
echo
echo "Thanks for using DisCovQC"