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
cut=c(args[3])
cut=as.numeric(cut)
columns=c(args[4])
columns=as.numeric(columns)

#create plot lists
plot_1_list = list()
plot_2_list = list()

#required packages
library.path <- .libPaths()
library(ggplot2, lib.loc = library.path)
library(mdthemes, lib.loc = library.path)
library(htmlwidgets, lib.loc = library.path)
library(plotly, lib.loc = library.path)
library(gridExtra, lib.loc = library.path)

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
for (sample in list) {
#load data
bed <- read.table(paste(c('',sample,'.regions.bed.gz'),collapse=''),header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
bed <- as.data.frame(bed)

## y-limit on plot the same (maxd) for all samples

p1 = ggplot(bed) + 
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

#saveWidget(ggplotly(), file = paste(c('HTMLs/DisCovPlotComp.',sample,'.html'),collapse=''))
#ggsave(filename = paste(c('Images/DisCovPlotComp.',sample,'.png'),collapse=''), width = 7, height = 5)

#assign sample name to plot 1 to be added to list of comparative plots
assign(paste("plot1",sample,sep = "_"),p1)
plot_1_list = append(plot_1_list, paste("plot1",sample,sep = "_"))

## y-limit based on maximum depth with cutoff line

max = max(bed$V4)

p2 = ggplot(bed) + 
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
  geom_hline(yintercept=10, linetype = "dashed", color = "green", size = 1) +
  ggtitle(sample)

#saveWidget(ggplotly(), file = paste(c('HTMLs/DisCovPlot.',sample,'.html'),collapse=''))
#ggsave(filename = paste(c('Images/DisCovPlot.',sample,'.png'),collapse=''), width = 7, height = 5)

#assign sample name to plot 2 to be added to list of plots
assign(paste("plot2",sample,sep = "_"),p2)
plot_2_list = append(plot_2_list, paste("plot2",sample,sep = "_"))

cat("Plots for ",sample," complete\n")
}

#create lists for making grids
plotlist1 <- mget(ls(pattern = "plot1"))
plotlist2 <- mget(ls(pattern = "plot2"))

##subplot
#rows = ceiling(length(list)/columns)
#subplot(l, nrows=rows) ##works but doesn't have headers...that's a problem

##use grid.arrange to create grid
#can also do.call plot_grid with cowplot
final_plot1 = do.call(grid.arrange, c(plotlist1, ncol = columns))
final_plot2 = do.call(grid.arrange, c(plotlist2, ncol = columns))

#save grid as PNG
ggsave(final_plot1, filename = 'Images/DisCovPlotComp.All.png')
ggsave(final_plot2, filename = 'Images/DisCovPlot.All.png')

print('All plots saved in grid')