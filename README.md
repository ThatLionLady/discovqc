# DisCovQC

This script creates plots of coverage distribution for any number of samples at any bin size displayed in an HTML file for easy scrolling **to determine which samples and regions are appropriate to include in further analyses**.

This script uses [mosdepth](https://github.com/brentp/mosdepth) for fast mean per-window depth calculation. While this script only uses the BED output, [mosdepth](https://github.com/brentp/mosdepth) also provides global and regional distribution tables and a summary of mean depths that can be helpful elsewhere.  

Two final HTML output files are created:
1. plots with the same y-axis for direct comparison and
2. plots with the y-axis at max depth for each sample with a minimum cutoff indicated for individual assessment.

The max depth for the comparative plots is determined by finding the max depth across all samples and rounding to the nearest 10. 

All plots are created with ggplot2 and saved as PNGs and interactive plotly HTML files. These individual plots are then strung together into a grid. 

**TIP:** *Images are embedded into the HTML file via absolute path so moving the image files will render the HTML file useless. HTML files can be moved. Or just keep everything as it. Don't worry. The output is organized and easy to maneuver.*

# "Installation"

Unix Packages Required:
- [mosdepth](https://github.com/brentp/mosdepth)
- Rscript

R Packages Required: 
- ggplot2
- mdthemes
- htmlwidgets
- plotly
- gridExtra

Download all files:
```sh
git clone https://github.com/ThatLionLady/discovqc
```
Make main script executable:
```sh
cd discovqc
chmod u+x Scripts/DisCovQC.sh
```

# Usage

It's relatively quick to run: 500 samples took 25 minutes.

To run with the paramfile:

```sh
./DisCovQC.sh $(cat paramfile)
```

Run in the background with a progress log:

```sh
screen -S discovqc -dm ./DisCovQC.sh $(cat paramfile) &> DisCovQC.log
```

View output

```sh
browsername DisCovPlot.All.html
browsername DisCovPlotComp.All.html
```

# Paramfile

The **paramfile** is a text file with 11 lines of arguments:
1. SAMPLES = Path to list of sample names (*i.e. /Lists/samplelist.txt*)
2. BAMDIR = Path to BAMs (*i.e. /BAMs/*)
3. BAM = BAMs file name (*i.e. .mapped.sorted*)
4. OUT = Path to out directory (*i.e. /DisCov/*)
5. CHROM = Chromosome to restrict depth calculation (*i.e. Mitogenome*)
6. BINS = Bin width (*i.e. 100*)
7. PROG = Path to scripts directory (*i.e. /Scripts/*)
8. CUT = Cutoff value for minimum read depth (*i.e. 10*)
9. COLS = Number of columns for grid output (*i.e. 4*)
10. THREADS = Number of threads (*i.e. 16*)

**TIP:** *If you get an `SIGSEGV: Illegal storage access. (Attempt to read from nil?)` error, check your samples list to make sure it has Unix line endings. Windows line ending cause all kinds of problems!*

# Scripts

## **Main Scripts**
- *DisCovQC.sh*
- *DistributedCoverage-wBashArgList.R*

## **Other Scripts**
- *DisCovQC_makeHTML.sh*: post Rscript for making the HTML file of plots (can be ANY plots!)

    ```sh
    bash DisCovQC_makeHTML.sh 1 2 3
    ```

    1. sample size
    2. out directory
    3. file name

- *DisCovQC_grid.sh*: use DistributedCoverage-wBashArgList-Grid.R in paramfile
    > Only "works" (i.e. looks good) for less than about 20 samples! Moreso here because the script does work and could be used to help develope something else in the future.

- *DisCovQC_markdown.sh*: to make a markdown file instead of an HTML. Uses *DistributedCoverage-wBashArgList.R* in paramfile.

- *DistributedCoverage-Individual.R*: Can be opened in rstudio to manually make plots for an individual sample. 

- *DistributedCoverage-wBashArgList-Grid.R*: Rscript with bash arguments for use with *DisCovQC_grid.sh* for making a grid plot from a list.

# Example Output

Here is a screenshot of some example output of:
- Sample size = 12
- Bin size = 200
- Cutoff value = 5
- Columns = 5

![example output](image.png)
