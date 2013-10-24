## one script to rule them all
setwd("~/Statistics/stat545A/Final Project")
## clean out any previous work
outputs <- c("result/DataFormat.tsv",             # DataCleaning.R
             "data/CleanData.TSV",                # DataCleaning.R
             "data/SortData.tsv",                 # DataAggre.R
             "data/TotalFirePerYr.tsv",           # DataAggre.R
             "data/TotalFirePerYrCau.tsv",        # DataAggre.R
             "data/TotalFirePerYrProCau.tsv",     # DataAggre.R
             "data/TotalFirePerYearMon.tsv",       # DataAggre.R
             "data/TotalFireByYrMon.tsv",         # DataAggre.R
              paste0("figure/",list.files(path = "figure/.", pattern = "*.png$")))
file.remove(outputs)

## run my scripts
source("code/DataCleaning.R")
source("code/DataAggre.R")
source("code/FigureMaking.R")

