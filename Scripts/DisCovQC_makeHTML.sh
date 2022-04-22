#!/bin/sh

echo "So you have the data and the plots are done but you still need that HTML."
echo
echo "This might take a hot second..."
echo

# calculate number of samples

N=$(wc -l < ${1})

OUT=${2}
cd ${OUT}Data/Images
FILE=${3}

# make HTML header for file with comparable plots grid

echo '<!DOCTYPE html>' >> ${OUT}${FILE}.All.html
echo '<html>' >> ${OUT}${FILE}.All.html
echo '<body>' >> ${OUT}${FILE}.All.html
echo '<style>' >> ${OUT}${FILE}.All.html
echo 'h2 {text-align: center;}' >> ${OUT}${FILE}.All.html
echo 'h3 {text-align: center;}' >> ${OUT}${FILE}.All.html
echo 'h4 {text-align: center;}' >> ${OUT}${FILE}.All.html
echo '.adjust-line-height {line-height: 25%;}' >> ${OUT}${FILE}.All.html
echo '</style>' >> ${OUT}${FILE}.All.html
echo '' >> ${OUT}${FILE}.All.html
echo '<div class="adjust-line-height">' >> ${OUT}${FILE}.All.html
echo '<h2>Distribution of Coverage for Quality Contol</h2>' >> ${OUT}${FILE}.All.html
echo '<h4><i>Individual Plots DisCovQC Output</i></h4>' >> ${OUT}${FILE}.All.html
echo "<h3><b>N=${N}</b></h3>" >> ${OUT}${FILE}.All.html
echo '</div>' >> ${OUT}${FILE}.All.html
echo '<table>' >> ${OUT}${FILE}.All.html
echo '<tbody>' >> ${OUT}${FILE}.All.html
echo '<tr>' >> ${OUT}${FILE}.All.html

# add grids

declare -a Issues=( DisCovPlot.*.png );

for((n=0;n<${#Issues[@]};n++)); do
        if (( $(($n % $COLS )) == $(($COLS-1)) )); 
                # Run every 4 entries
                then echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>\n</tr>\n<tr>" >> ${OUT}${FILE}.All.html
                else echo -e "<td style=\"text-align: center;\"><img src=\"${OUT}Data/Images/${Issues[$n]}\" width=100% height=auto /></td>" >> ${OUT}${FILE}.All.html
        fi
done

echo '</tr>' >> ${OUT}${FILE}.All.html
echo '</body>' >> ${OUT}${FILE}.All.html
echo '</html>' >> ${OUT}${FILE}.All.html

# All done!

echo "Just kidding :D"
echo "It's super quick ;)"
echo
echo "Thanks for using DisCovQC"