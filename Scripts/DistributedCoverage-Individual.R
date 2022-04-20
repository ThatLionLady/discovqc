#developed in R v4.1.2 (local)

#arguments (change ****)
sample=****
bins=****
cut=****

#required packages
library.path <- .libPaths()
library(ggplot2, lib.loc = library.path)
library(mdthemes, lib.loc = library.path)
library(htmlwidgets, lib.loc = library.path)
library(plotly, lib.loc = library.path)

#load data
bed <- read.table(paste(c('',sample,'.regions.bed.gz'),collapse=''),header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
bed <- as.data.frame(bed)

#find max read depth and round to nearest 10
maxd=max(bed$V4)
maxd=plyr::round_any(maxd, 10, f = ceiling)

#create individual plots

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
  
saveWidget(ggplotly(), file = paste(c('DisCovPlotComp.',sample,'.html'),collapse=''))
ggsave(filename = paste(c('DisCovPlotComp.',sample,'.png'),collapse=''), width = 7, height = 5)
  
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
  
saveWidget(ggplotly(), file = paste(c('DisCovPlot.',sample,'.html'),collapse=''))
ggsave(filename = paste(c('DisCovPlot.',sample,'.png'),collapse=''), width = 7, height = 5)
