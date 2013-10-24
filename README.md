### STAT 545A Final Project: Explore the temporal and spatial distribution of Canadian Large Fire
#### Yumian Hu
__2013-10-21__

-------------------------------------------------------------------------------------------------------------
#### Introduction
In this project, I use the **Canadian Large Fire Database (LFDB)** to explore the temporal and spatial distribution 
and association of landscape-scale fire in Canada. LFDB is a compilation of forest fire data from all Canadian agencies, 
including provinces, territories, and Parks Canada. For more information, please visit website of 
[Natural Resources Canada](http://cwfis.cfs.nrcan.gc.ca/en_CA/lfdb)

#### How to replicate my analysis
* Creat four new folders on an empty directory with names shown below:
  * data
  * code
  * figure
  * results
* Download the following files into the empty directory (or folders):
  * Download raw data [LFD_A02_5999_e.txt](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/LFD_A02_5999_e.txt) 
into data folder
  * Download all the scripts [DataCleaning.R](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/code/DataCleaning.R), 
[DataAggre.R](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/code/DataAggre.R), 
[FigureMaking.R](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/code/FigureMaking.R) and 
[SplineCurv.R](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/code/SplineCurv.R) into code folder.
  * Download Makefile script [Makefile.R](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/Makefile.R) into 
the main directory.
* Start a fresh RStudio session, open `Makefile.R`, substitute the path in the `setwd()` with the path of the above directory,
and click on "Source".
* New files you should see after running the pipeline:
  *  Data aggregation result: 
    * [CleanData.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/CleanData.tsv) 
    * [SortData.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/SortData.tsv)
    * [TotalFirePerYr.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYr.tsv)
    * [TotalFirePerYrCau.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYrCau.tsv)
    * [TotalFirePerYearMon.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYearMon.tsv)
    * [TotalFireByYrMon.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFireByYrMon.tsv)
    * [TotalFirePerYrProCau.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYrProCau.tsv.tsv)

