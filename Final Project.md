## STAT 545A Final Project: Explore the temporal and spatial distribution of Canadian Large Fire
### Yumian Hu
__2013-10-21__

###  <dim id="1a">[Introduction](#1a)
In this project, I will use the **Canadian Large Fire Database (LFDB)** to explore the temporal and spatial distribution and association of landscape-scale fire in Canada. LFDB is a compilation of forest fire data from all Canadian agencies, including provinces, territories, and Parks Canada. The data set includes only fires greater than 200 hectares in final size; these represent only a few percent of all fires but account for most of the area burned (usually more than 97%). For more information, please visit website of [Natural Resources Canada](http://cwfis.cfs.nrcan.gc.ca/en_CA/lfdb), LFDB can also be downloaded ditrectly from this webpage.

All the data, code and figures for the project can be found on my [Github](https://github.com/smilecat/stat545a-2013-hw06_hu-yum).

### <dim id="2a">[Big Picture](#2a)
In thie project, I will explore from the following aspects.
* <dim id="3a">[Data Description and Import](#3b)
* <dim id="4a">[Temporal Distribution of Large Fire](#4b)
  * <dim id="4.1a">[How does Fire Frequency Change over Year?](#4.1b)
  * <dim id="4.2a">[How does Fire Size Change over Month?](#4.2b)
* <dim id="5a">[Spatial Distribution of Large Fire](#5b)
  * <dim id="5.1a">[Fire Frequency in Different Provinces](#5.1b)
  * <dim id="5.2a">[Fire Frequency seen from Google Map](#5.2b)
  * <dim id="5.3a">[Emulate Real Map with `ggplot2`](#5.3b) 
* <dim id="6a">[Buble Chart: Seen from both Temporal and Spatial Aspects](#6b)
* <dim id="7a">[Heatmap: Is the monthly distribution of Fire Frequency same every Year? ](#7b)
* <dim id="8a">[Cubic Spline: Fluctuation of Fire Frequency over Year in Different Provinces](#8b)
* <dim id="9a">[Conclusion](#9b)


### <dim id="3b">[Data Description and Import](#3a)
The dataset is comma-delimited ASCII, named "LFD_A02_5999_e.txt" originally, with each row representing a record for a given fire. 
The raw data incorporates the following 16 variables: 
* `Year`, `Month`, `Day`, `Province`, `Fire_ID`, `Latitude`, `Longitude`, `Start_Date`, `Detect_Date`, `Cause`, `Size`, `Fire_Region`, `Fire_Zone`, `EcoZone`, `EcoRegion`, `EcoDistrict`. 

I include 8 most meaningful variables in my data analysis, and summarize thier information and description in the table below.

<!-- html table generated in R 3.0.0 by xtable 1.7-1 package -->
<!-- Thu Oct 24 02:13:26 2013 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable_Name </TH> <TH> Variable_Class </TH> <TH> Variable_Description </TH> <TH> Missing_Entry </TH> <TH> Missing_NumPer </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Year </TD> <TD> integer </TD> <TD> Year of fire start: from 1959 to 1999 </TD> <TD>  </TD> <TD> 0 (0.000) </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Month </TD> <TD> integer </TD> <TD> Month of fire start (No January, strange) </TD> <TD> 0 </TD> <TD> 111 (0.010) </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Day </TD> <TD> integer </TD> <TD> Day of fire start </TD> <TD> 0 </TD> <TD> 112 (0.010) </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Province </TD> <TD> factor </TD> <TD> 11 levels: BC, AB, SK, MB, ON, QC, NF, NB, NS, YK, NWT </TD> <TD>  </TD> <TD> 0 (0.000) </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Latitude </TD> <TD> numeric </TD> <TD> Fire start location, from 42.56 to 68.98 </TD> <TD> 0 </TD> <TD> 79 (0.007) </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Longitude </TD> <TD> numeric </TD> <TD> Fire start location, from -141 to -52.65 </TD> <TD> 0 </TD> <TD> 79 (0.007) </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Cause </TD> <TD> factor </TD> <TD> 3 levels: MAN (human), LTG (lightning), UNK (unknown) </TD> <TD> UNK </TD> <TD> 354 (0.032) </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Size </TD> <TD> numeric </TD> <TD> Final fire size in hectares </TD> <TD>  </TD> <TD> 0 (0.000) </TD> </TR>
   </TABLE>

> There is no record of January in the dataset, quite strange.
 
* One needs to sepecify the arguments `quot="\""` and `comment.char=""` when importing the raw data, since there are symbols of `'` and `#` in the dataset. 
* I assume most of the missing data is missing completely at random, which can be directly excluded from the dataset. However, I keep "UNK" Fire Causes (entry of missing value for `Cause`) in my clean dataset since its percentage is relatively large and it seems to have some missing pattern (all the fire causes in BC in 1999 were unkown!). 
* I have already excluded two levels of Province, WBNP (Wood Buffalo National Park) and NP (National Park) from the raw data, which I think hard to make comparison with "real"" provinces.
* Please visit [Wikipedia](http://en.wikipedia.org/wiki/Canadian_postal_abbreviations_for_provinces_and_territories) for more information about Canadian provinces and their abbreviations. Since the Large Fire Database is not updated, it incorporate some old versions of abbreviations, I update them in the clean dataset with "PQ", "NWT", "NF", "YK" changed to "QC", "NT", "NL" and "YT".
* There are 11231 rows and 16 column in the raw dataset. After some data cleaning and maniputaion, there are 10874 rows of 8 columns left in the clean dataset.

Now let's import the clean dataset and load necessary packages.




```r
> jDat <- read.table("data/CleanData.tsv", header=T)
```



```r
> library(plyr)          # for data aggregation
> library(RColorBrewer)  # for color setting
> library(ggplot2)       # for advanced figure plotting 
> library(gplots)        # for heatmap
```

```
KernSmooth 2.23 loaded Copyright M. P. Wand 1997-2009

Attaching package: 'gplots'

The following object is masked from 'package:stats':

lowess
```

```r
> library(RgoogleMaps)   # for showing map of Canada
```

```
Loading required package: png Loading required package: RJSONIO
```


Perform a superficial check that data import went OK.

```r
> str(jDat)
```

```
'data.frame':	10874 obs. of  8 variables:
 $ Year     : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
 $ Month    : int  5 5 5 5 5 5 5 5 7 5 ...
 $ Day      : int  15 14 17 17 16 21 14 22 31 15 ...
 $ Province : Factor w/ 11 levels "AB","BC","MB",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ Latitude : num  54.5 55.6 55.3 54.8 56.2 ...
 $ Longitude: num  -111 -116 -116 -117 -120 ...
 $ Cause    : Factor w/ 3 levels "LTG","MAN","UNK": 2 2 2 1 2 2 2 2 1 2 ...
 $ Size     : num  1190 478 607 245 260 ...
```

```r
> head(jDat)
```

```
  Year Month Day Province Latitude Longitude Cause   Size
1 1959     5  15       AB    54.46    -111.2   MAN 1190.3
2 1959     5  14       AB    55.61    -116.5   MAN  477.7
3 1959     5  17       AB    55.30    -116.4   MAN  607.3
4 1959     5  17       AB    54.76    -117.3   LTG  245.3
5 1959     5  16       AB    56.24    -119.7   MAN  259.5
6 1959     5  21       AB    56.28    -119.6   MAN  696.4
```


Reorder the levels of Province: From West to East and from South to North and sort the data by Year and Month

```r
> ProLevels <- c("BC", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "NL", "YT", "NT")
> jDat <- arrange(transform(jDat, Province = factor(Province, levels = ProLevels)), Province)
> jDat <- jDat[with(jDat, order(Year, Month, Day, Province, Size)), ]
> str(jDat)
```

```
'data.frame':	10874 obs. of  8 variables:
 $ Year     : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
 $ Month    : int  4 4 5 5 5 5 5 5 5 5 ...
 $ Day      : int  1 27 8 10 10 11 11 12 12 12 ...
 $ Province : Factor w/ 11 levels "BC","AB","SK",..: 1 2 3 1 6 1 1 1 1 1 ...
 $ Latitude : num  60 55.1 53.6 56.6 47.5 ...
 $ Longitude: num  -133.6 -116.4 -108.7 -122 -77.3 ...
 $ Cause    : Factor w/ 3 levels "LTG","MAN","UNK": 2 2 2 2 2 2 2 2 2 2 ...
 $ Size     : num  3205 317 1069 514 263 ...
```


### <dim id="4b">[Temporal Distribution of Large Fire](#4a)
As a basic check, let's first look at how Fire Frequency and Fire Size change with time.

#### <dim id="4.1b">[How does Fire Frequency Change over Year](#4.1a)
<img src="figure/unnamed-chunk-71.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="50%" /><img src="figure/unnamed-chunk-72.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="50%" />


I plot the total number of Large Fire against Year, and grouped by Causes in the right figure. There is no obvious increasing or decreasing trend for fire frequency. It's rather fluctuated with its peak at the year of 1979. Most of the fire, of course, was caused by lightning but still rather amount was caused by human, especially from 1959 to 1969.

#### <dim id="4.2b">[How does Fire Size Change over Month](#4.2a)
![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

To make the above figure, I choose records from year 1959, 1969, 1979, 1989 and 1999, plot the log transformed fire size against its happening month and wrap by province. Most of the provinces show the similar volcano shape, centered from May to August, which implies that Summer and Autumn is the frequent seasons for large fire. 

### <dim id="5b">[Spatial Distribution of Large Fire](#5a)
Let's move to the spatial part, look at the geographically distribution of Large Fire location every 5 years from 1959 to 1999.

#### <dim id="5.1b">[Fire Frequency in Different Provinces](#5.1a)
![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 

It's noticed that in BC Province, a major percentage of large fire was cuased by human being!

#### <dim id="5.2b">[Fire Frequency seen from Google Map](#5.2a)
Since the dataset incorporate Latitude and Longitude of each Fire, I can download the GoogleMap of Canada and plot the fire location in this map. You need to install `RgoogleMaps` package first. 

```r
> center = c(mean(jDat$Latitude), mean(jDat$Longitude))
> zoom <- min(MaxZoom(range(jDat$Latitude), range(jDat$Longitude)))
> GeoMap <- GetMap(center = center, zoom = zoom, destfile = "figure/capre.png")
```

```
[1] "http://maps.google.com/maps/api/staticmap?center=55.9010302651573,-103.490342349641&zoom=3&size=640x640&maptype=mobile&format=png32&sensor=true"
```

```r
> gDat <- subset(jDat, Year %in% jYear)
> PlotOnStaticMap(GeoMap, lat = gDat$Latitude, lon = gDat$Longitude, 
+                 destfile ="figure/capre.png", cex = 0.5, pch = 20, col = "red")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


#### <dim id="5.3b">[Emulate Real Map with `ggplot2`](#5.3a) 
I would like to emulate it with `ggplot2` and distinguish Month by different colors. 
![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

Again it shows the seasonal trendence with the most Fire happening from May to August and in the middle of Canada (SK, MB, ON). 

### <dim id="6b">[Buble Chart: Seen from both Temporal and Spatial Aspects](#6a)
In this part, I will replicate the Bubble Chart from Gapminder Project, which displays both the Temporal and Spatial trends of Large Fire. Based on the above figure, I make the area of solid circle proportional to its fire size at that location (not the exact fire size if it exceeds its provincial territory).

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 

* Some super large fire happened in July, so there are not only frequent fire but also large fire happening in summer.
* There was a huge fire happened in the area around YT and NT in 1979. But there is no fixed pattern of geographical distribution for large fire. 

### <dim id="7b">[Heatmap: Is the monthly distribution of Fire Frequency same every Year?](#7a)
To better show the temporal distribution of fire, I use heatmap to demonstrate the number of fire happening at every month and year. The darker the blue is, the more fire it presents. 

```r
> gDat <- daply(jDat, ~ Year + Month, function(x) length(x$Year))
> ## replace NA with 0 in the gDat
> gDat[is.na(gDat)] <- 0
> gDat <- as.data.frame(gDat)
> colnames(gDat) <- paste0("Month ",colnames(gDat))
> rownames(gDat) <- paste0("Year ", rownames(gDat))
> gDat <- as.matrix(t(gDat))
> gBuPuFun <- colorRampPalette(brewer.pal(n = 9, "BuPu"))
> heatmap.2(gDat, col = gBuPuFun, trace = "none", main = "Heatmap of the Number of Fire")
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 


To explore whether the monthly distribution of fire frequency similar in  every year, I first calculate the correlation between every two years and then show the result with heatmap.

```r
> gDatCor <- cor(gDat)
> heatmap.2(gDatCor, col = gBuPuFun, trace = "none", 
+           main = "Heatmap of Correlation among Years")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 


It shows that the color of grid between year 1960 and 1995 is the lightest, which indicates the lowest correlation. We can also demonstrate it from the correlation matrix.


```r
> min(gDatCor) 
```

```
[1] 0.112
```

```r
> minrow <- which.min(gDatCor) %/% nrow(gDatCor) + 1
> mincol <- which.min(gDatCor) %% nrow(gDatCor)
> gDatCor[minrow, mincol] == min(gDatCor)
```

```
[1] TRUE
```

```r
> (year1 <- as.numeric(substr(rownames(gDatCor)[minrow], 6, 9)))
```

```
[1] 1960
```

```r
> (year2 <- as.numeric(substr(colnames(gDatCor)[mincol], 6, 9)))
```

```
[1] 1995
```


Let's plot the monthly trend of fire frequency for each year and highlight the year 1960 and 1995.
![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 


### <dim id="8b">[Cubic Spline: Fluctuation of Fire Frequency over Year in Different Provinces](#8a)
The following figure displays the fire frequency trend over year in each province. Most of them are quite fluctuated which makes it meaningless to fit a linear regression line. However, we can still compare the fluctuation of fire frequency among different provinde. 

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17.png) 


I first fit a cubic spline (a cubic spline is a spline constructed of piecewise third-order polynomials which pass through a set of control points) for each type of fire cause per province. Then I use the average curvature (curvature/length of year) as a representative of fluctuation of trend; the larger the average curvature is, the more fluctuation the curve has. 
> I drop the province of "NB" and "NS" since they don't have enough number of points (at least four) to fit the cubic spline.

<!-- html table generated in R 3.0.0 by xtable 1.7-1 package -->
<!-- Thu Oct 24 02:13:38 2013 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> LTG </TH> <TH> MAN </TH>  </TR>
  <TR> <TD align="right"> NT </TD> <TD align="right"> 17251.58 </TD> <TD align="right"> 58.30 </TD> </TR>
  <TR> <TD align="right"> MB </TD> <TD align="right"> 10945.36 </TD> <TD align="right"> 3269.13 </TD> </TR>
  <TR> <TD align="right"> ON </TD> <TD align="right"> 10026.15 </TD> <TD align="right"> 111.81 </TD> </TR>
  <TR> <TD align="right"> SK </TD> <TD align="right"> 8025.57 </TD> <TD align="right"> 360.97 </TD> </TR>
  <TR> <TD align="right"> QC </TD> <TD align="right"> 4141.79 </TD> <TD align="right"> 298.78 </TD> </TR>
  <TR> <TD align="right"> BC </TD> <TD align="right"> 3101.90 </TD> <TD align="right"> 2978.33 </TD> </TR>
  <TR> <TD align="right"> YT </TD> <TD align="right"> 2793.78 </TD> <TD align="right"> 7.18 </TD> </TR>
  <TR> <TD align="right"> NL </TD> <TD align="right"> 729.91 </TD> <TD align="right"> 68.84 </TD> </TR>
  <TR> <TD align="right"> AB </TD> <TD align="right"> 680.95 </TD> <TD align="right"> 894.57 </TD> </TR>
   </TABLE>

* The yearly total fire caused by lightning fluctuated the most in NT Province.
* The yearly total fire caused by human being fluctuated the most in MB Province.

### <dim id="9b">[Conclusion](#9a)
Through this exploratory data analysis journey, I find some preliminary interesting phenomena in the large fire dataset. There is a seasonal trend and geographical pattern in the distribution of fire frequency and fire size. For more information, the following papers present analyses of this database, which are recommended on the Website of [Natural Resources Canada](http://cwfis.cfs.nrcan.gc.ca/en_CA/lfdb).

* [Parisien, M.A.; Peters, V.S; Wang, Y.; Little, J.M.; Bosch, E.M.; Stocks, B.J. 2006. Spatial patterns of forest fires in Canada 1980-1999. Int. J. Wildland Fire 15:361-374.](http://www.publish.csiro.au/?act=view_file&file_id=WF06009.pdf)
* [Stocks, B.J.; Mason, J.A.; Todd, J.B.; Bosch, E.M.; Wotton, B.M.; Amiro, B.D.; Flannigan, M.D.;Hirsch, K.G.; Logan, K.A.; Martell, D.L.; Skinner, W.R. 2002. Large forest fires in Canada, 1959-1997. Journal of Geophysical Research (107,8149,doi:10.1029/2001 JD000484).](http://se-server.ethz.ch/staff/af/Fi159/S/Sto047.pdf)
