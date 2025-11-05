### The demographic history of Oophaga vicentei was estimated using 
# ANGSD v 0.938 (Korneliussen et al., 2014), and Stairway Plot v2.1 (Liu & Fu, 2020).
# Results were further plotted using R. 

Author: Anaisa Cajigas Gandia (script modified from an original provided by Ariel Rodríguez)
License: GNU
Last updated: 30.10.2025

# missing script from ANGSD  and Stairway plot from Ariel #

### Plotting in R ###
setwd
library(ggplot2)
library(scales)
CEI<-read.csv("Oophaga vicentei  CEI realSFS all sites.final.summary",
              sep="\t")
CEI$Population<-"CEI"
West<-read.csv("Oophaga vicentei  West realSFS all sites.final.summary",
               sep="\t")
West$Population<-"WEST"


joint.SWP<-rbind(CEI, West)
summary(joint.SWP)

ggplot(joint.SWP, aes(x=year, y=Ne_median, group=Population))+
  geom_step(aes(linetype=Population, color=Population)) +
  geom_ribbon(aes(ymin= Ne_12.5. , ymax=Ne_87.5., fill=Population), alpha=0.15) +
  theme_classic() + coord_cartesian(xlim =c(100, 3000000))+
  scale_x_continuous(trans="log", 
                     labels=label_number(accuracy=1,scale = 1/1000),  
                     breaks=c(1000,2500,10000,25000,100000, 250000, 1000000, 3000000)) +
  scale_y_continuous(trans="log",
                     labels = unit_format(unit = "000", scale = 1e-3)) +
  #scale_x_continuous(limits = c(1000, 2000000))+
  #coord_trans(x="log") +
  scale_color_manual(values=c("#54c099", "red2")) +
  scale_fill_manual(values=c("#54c099", "red2")) +
  annotate("rect", xmin = 114000, xmax = 131000, 
           ymin = min(joint.SWP$Ne_12.5), ymax = max(joint.SWP$Ne_87.5), 
           alpha = .55) +
  annotate("rect", xmin = 20000, xmax = 26000, 
           ymin = min(joint.SWP$Ne_12.5), ymax = max(joint.SWP$Ne_87.5), 
           alpha = .25) +
  xlab("Time (x1000 years ago)") + ylab("Effective population size (Ne)") +
  theme(
    axis.title = element_text(size = 28, colour = "black"),  # black axis titles
    axis.text = element_text(size = 24, colour = "black"),   # black tick labels
    legend.title = element_text(size = 22, colour = "black"),# black legend title
    legend.text = element_text(size = 20, colour = "black"), # black legend text
    plot.title = element_text(size = 20, hjust = 0.5, colour = "black") # black title
  )

ggsave("stairway_plot_vicentei_75CI.pdf", width=16, height=10)

ggsave(
  filename = "stairway_plot_vicentei_75CI.jpg",
  plot = last_plot(),   # saves the most recent plot
  dpi = 300,            # high resolution
  units = "in"
)
