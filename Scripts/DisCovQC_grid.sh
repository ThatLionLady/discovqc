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

# use DistributedCoverage-wBashArgList-Grid.R 

Rscript ${PROG}DistributedCoverage-wBashArgList-Grid.R ${1} ${BINS} ${CUT} ${COLS}

mv ${OUT}Data/Images/DisCovPlotComp.All.png ${OUT}
mv ${OUT}Data/Images/DisCovPlot.All.png ${OUT}

echo "Plots are done."
echo "Time to put it all together."
echo
echo "This might take a hot second..."
echo

N=$(wc -l < ${1})

#make HTML file with comparable plots grid
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
echo '<img src="DisCovPlotComp.All.png" width=100% height=auto>' >> ${OUT}DisCovPlotComp.All.html
echo '' >> ${OUT}DisCovPlotComp.All.html
echo '</body>' >> ${OUT}DisCovPlotComp.All.html
echo '</html>' >> ${OUT}DisCovPlotComp.All.html

#make HTML file with plots grid
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
echo '<img src="DisCovPlot.All.png" width=100% height=auto>' >> ${OUT}DisCovPlot.All.html
echo '' >> ${OUT}DisCovPlot.All.html
echo '</body>' >> ${OUT}DisCovPlot.All.html
echo '</html>' >> ${OUT}DisCovPlot.All.html

echo "Just kidding :D"
echo "It's super quick ;)"
echo
echo "Thanks for using DisCovQC"