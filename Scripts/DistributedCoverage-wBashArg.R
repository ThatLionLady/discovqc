#!/usr/bin/env Rscript
#developed in R v4.1.2 (local)

args = commandArgs(trailingOnly=TRUE)

print("Bash Arguments")
print(args)

#arguments
list=read.table(args[1], header = FALSE) 
list=as.character(list[,1])
bins=c(args[2])
bins=as.numeric(bins)
cut=c(args[4])
cut=as.numeric(cut)
columns=c(args[5])
columns=as.numeric(columns)

#required packages
library.path <- .libPaths()
library(ggplot2, lib.loc = library.path)
library(mdthemes, lib.loc = library.path)
library(htmlwidgets, lib.loc = library.path)
library(plotly, lib.loc = library.path)
library(gridExtra, lib.loc = library.path)

#determine maxd for comparison

#find number of rows and make a blank dataframe
sample=list[[1]][1]
bed <- read.table(paste(c('',sample,'.regions.bed.gz'),collapse=''),header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
bed <- as.data.frame(bed)
dfrows=nrow(bed)
df <- data.frame(matrix(ncol = 0, nrow = dfrows))

#create a dataframe of read depths
for (sample in list) {
  bed <- read.table(paste(c('',sample,'.regions.bed.gz'),collapse=''),header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
  bed <- as.data.frame(bed)
  df <- cbind(df, sample = bed$V4)
}

#find max read depth and round to nearest 10
maxd=max(df)
maxd=plyr::round_any(maxd, 10, f = ceiling)

#create individual plots

#load data
for (sample in list) {
  bed <- read.table(paste(c('',sample,'.regions.bed.gz'),collapse=''),header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
  bed <- as.data.frame(bed)

## y-limit on plot the same (maxd) for all samples

ggplot(bed) + 
  geom_rect(aes(xmin=V2,xmax=V3,ymin=0,ymax=V4), 
            fill="grey32") +
  mdthemes::md_theme_classic() +
  scale_x_continuous(name = paste(c('Position<br>*',bins,' bp windows*'),collapse=''), 
                     limits = c(0,16293), 
                     expand = c(0, 0),
                     breaks = seq(0,16293,1000),
                     labels = c("0","1K","2K","3K","4K","5K","6K","7K","8K","9K","10K","11K","12K","13K","14K","15K","16K")) + 
  scale_y_continuous(name = "Read Depth", 
                     limits = c(0,maxd), 
                     expand = c(0, 0)) + 
  ggtitle(sample)

saveWidget(ggplotly(), file = paste(c('HTMLs/DisCovPlotComp.',sample,'.html'),collapse=''))
ggsave(filename = paste(c('Images/DisCovPlotComp.',sample,'.png'),collapse=''), width = 7, height = 5)

## y-limit based on maximum depth with cutoff line

max = max(bed$V4)

ggplot(bed) + 
  geom_rect(aes(xmin=V2,xmax=V3,ymin=0,ymax=V4), 
            fill="grey32") +
  mdthemes::md_theme_classic() +
  scale_x_continuous(name = paste(c('Position<br>*',bins,' bp windows*'),collapse=''), 
                     limits = c(0,16293), 
                     expand = c(0, 0),
                     breaks = seq(0,16293,1000),
                     labels = c("0","1K","2K","3K","4K","5K","6K","7K","8K","9K","10K","11K","12K","13K","14K","15K","16K")) + 
  scale_y_continuous(name = "Read Depth", 
                     limits = c(0,if(max < cut) {
                       12
                     } else {
                       max+1
                     }), 
                     expand = c(0, 0)) + 
  geom_hline(yintercept=cut, linetype = "dashed", color = "green", size = 1) +
  ggtitle(sample)

saveWidget(ggplotly(), file = paste(c('HTMLs/DisCovPlot.',sample,'.html'),collapse=''))
ggsave(filename = paste(c('Images/DisCovPlot.',sample,'.png'),collapse=''), width = 7, height = 5)

cat("Plots for ",sample," complete\n")
}
