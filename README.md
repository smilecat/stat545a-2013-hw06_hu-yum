### STAT 545A Final Project: Explore the temporal and spatial distribution of Canadian Large Fire
#### Yumian Hu
__2013-10-21__

-------------------------------------------------------------------------------------------------------------
#### Introduction
In this project, I use the **Canadian Large Fire Database (LFDB)** to explore the temporal and spatial distribution 
and association of landscape-scale fire in Canada. LFDB is a compilation of forest fire data from all Canadian agencies, 
including provinces, territories, and Parks Canada. For more information, please visit website of 
[Natural Resources Canada](http://cwfis.cfs.nrcan.gc.ca/en_CA/lfdb)

The report of my project can be found on [rpubs](http://rpubs.com/smilecat/stat545a-2013-hw06_hu-yum).

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

#### New files you should see after running the pipeline:
*  Data aggregation results: 
  * [CleanData.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/CleanData.tsv)
 ---- Clean dataset used in the analysis after excluding variables, dropping levels of factors and removing missing values from the raw dataset.
  * [DataFormat.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/result/DataFormat.tsv)
 ---- Description of the dataset 
  * [SortData.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/SortData.tsv)
 ---- Rearrange the clean dataset by Year, Month, Province, Day and Size.
  * [TotalFirePerYr.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYr.tsv)
 ---- Count the total fire frequency per year
  * [TotalFirePerYrCau.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYrCau.tsv)
 ---- Count the total fire frequency by combinations of year and cause.
  * [TotalFirePerYearMon.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYearMon.tsv)
 ---- Count the total fire frequency by combinations of year and month (long format).
  * [TotalFireByYrMon.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFireByYrMon.tsv)
 ---- Count the total fire frequency by combinations of year and month (wide format).
  * [TotalFirePerYrProCau.tsv](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/data/TotalFirePerYrProCau.tsv.tsv)
 ---- Count the total fire frequency by combinations of year, province and cause.

*  Figures:
  * [FireGeoDis.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/FireGeoDis.png), 
[FireSizeByMon.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/FireSizeByMon.png), 
[FireSizeGeoDisMon.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/FireSizeGeoDisMon.png), 
[FireSizeGeoDisPro.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/FireSizeGeoDisPro.png), 
[FireSizeMonTrd.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/FireSizeMonTrd.png), 
[GoogleFireMap.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/GoogleFireMap.png), 
[HeatmapTotalFire.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/HeatmapTotalFire.png), 
[HeatmapYrCor.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/HeatmapYrCor.png), 
[TotalFirePerYearMon.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/TotalFirePerYearMon.png), 
[TotalFirePerYr.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/TotalFirePerYr.png), 
[TotalFirePerYrCau.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/TotalFirePerYrCau.png), 
[TotalFirePerYrPro.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/TotalFirePerYrPro.png), 
[TotalFirePerYrProCau.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/TotalFirePerYrProCau.png), 
[capre.png](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/capre.png), 
[capre.png.rda](https://github.com/smilecat/stat545a-2013-hw06_hu-yum/blob/master/figure/capre.png.rda)
