setwd("~/Statistics/stat545A/Final Project")

library(plyr)          # for data aggregation
library(RColorBrewer)  # for color setting
library(ggplot2)       # for advanced figure plotting 
library(gplots)        # for heatmap
library(RgoogleMaps)   # for showing map of Canada

#### How is Totoal Number of Large Fire Change over Year
gDat <- read.table("data/TotalFirePerYr.tsv", header=T)
ggplot(gDat, aes(x = Year, y = TotalFire)) + geom_point() + geom_line() + 
  theme_bw() + ggtitle("Total Number of Large Fire over Year")
ggsave(filename="figure/TotalFirePerYr.png")
dev.off()

gDat <- read.table("data/TotalFirePerYrCau.tsv", header=T)
ggplot(gDat, aes(x = Year, y = TotalFire, color = Cause)) + 
  geom_point() + geom_line() + theme_bw() +
  ggtitle("Total Number of Large Fire over Year by Different Causes")
ggsave(filename="figure/TotalFirePerYrCau.png")
dev.off()

#### How is Totoal Number of Large Fire Change over Month in different Provinces
gDat <- read.table("data/TotalFirePerYearMon.tsv", header=T)
## color setting for year
gColors <- brewer.pal(n = length(unique(gDat$Year)), name = "Set1")
names(gColors) <- sort(unique(gDat$Year))

ggplot(gDat, aes(x = Month, y = TotalFire, color = factor(Year))) + 
  geom_point() + geom_line() + theme_bw() + 
  scale_color_manual(values = gColors) + 
  ggtitle("Total Number of Large Fire over Month in Different Years")
ggsave(filename="figure/TotalFirePerYearMon.png")
dev.off()

#### How is Fire Size change over Month 
jDat <- read.table("data/CleanData.tsv", header=T)
ProLevels <- c("BC", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "NL", "YT", "NT")
jDat <- arrange(transform(jDat, Province = factor(Province, levels = ProLevels)), Province)

jColors <- brewer.pal(n = length(unique(jDat$Province)), name = "Set3")
names(jColors) <- unique(jDat$Province)

(jYear <- seq(from = 1959, to = 1999, by = 10))

ggplot(subset(jDat, Year %in% jYear), 
       aes(x = factor(Month), y = Size, color = Province)) + 
  scale_y_log10() + geom_point(alpha = I(0.2)) + geom_jitter() + 
  facet_wrap(~ Province, nrow = 4) + theme_bw() + 
  scale_color_manual(values = jColors) + 
  xlab("Month") + ylab("Fire Size") +
  ggtitle("Fire Size over Month in Different Province")

ggsave(filename="figure/FireSizeByMon.png")
dev.off()

#### How is the Fire Geographically Distributed?
## use "RgoogleMaps" focus on 1999
center = c(mean(jDat$Latitude), mean(jDat$Longitude))
zoom <- min(MaxZoom(range(jDat$Latitude), range(jDat$Longitude)))
GeoMap <- GetMap(center = center, zoom = zoom, destfile = "figure/capre.png")

(jYear <- seq(from = 1959, to = 1999, by = 5))
gDat <- subset(jDat, Year %in% jYear)

png(filename="figure/GoogleFireMap.png")
PlotOnStaticMap(GeoMap, lat = gDat$Latitude, lon = gDat$Longitude, 
                destfile ="figure/capre.png", cex = 0.5, pch = 20, col = "red")
dev.off()

## every 5 years from 1959 to 1999
gColors <- brewer.pal(n = length(unique(jDat$Month)), name = "Set3")
names(gColors) <- sort(unique(jDat$Month))

ggplot(gDat, aes(x = Longitude, y = Latitude, color = factor(Month))) + 
  geom_point(alpha = I(0.8)) + theme_bw() + 
  scale_color_manual(name = "Month", values = gColors) +
  ggtitle("Geographical Distribution of Large Fire")

ggsave(filename="figure/FireGeoDis.png")
dev.off()

## Focus on every 5 years, area of circle represents the size of fire, group by Province 
jDarkGray <- 'grey20'
ggplot(subset(jDat, Year %in% jYear), 
       aes(x = Longitude, y = Latitude, fill = Province)) + 
  geom_point(aes(size = sqrt(Size/pi)), pch = 21, color = jDarkGray) +
  scale_size_continuous(range=c(1,40)) + theme_bw() +  
  facet_wrap(~ Year) + 
  scale_fill_manual(values = jColors) +
  guides(size = FALSE) +
  ggtitle("Geographical Distribution of Large Fire by Province with Area Proportional to Fire Size")

ggsave(filename="figure/FireSizeGeoDisPro.png")
dev.off()

## Focus on every 5 years, area of circle represents the size of fire, group by Month 
ggplot(subset(jDat, Year %in% jYear), 
       aes(x = Longitude, y = Latitude, fill = factor(Month))) + 
  geom_point(aes(size = sqrt(Size/pi)), pch = 21, color = jDarkGray) +
  scale_size_continuous(range=c(1,40)) + theme_bw() +  
  facet_wrap(~ Year) + 
  scale_fill_manual(values = gColors) +
  guides(size = FALSE) +
  ggtitle("Geographical Distribution of Large Fire by Month with Area Proportional to Fire Size")

ggsave(filename="figure/FireSizeGeoDisMon.png")
dev.off()

#### Heatmap
## Total number of fire 
gDat <- read.table("data/TotalFireByYrMon.tsv", header=T)
str(gDat)
gDat <- as.matrix(t(gDat))
gBuPuFun <- colorRampPalette(brewer.pal(n = 9, "BuPu"))

png(filename="figure/HeatmapTotalFire.png")
heatmap.2(gDat, col = gBuPuFun, trace = "none", main = "Heatmap of the Number of Fire")
dev.off()

## Correlation among Different Years
gDatCor <- cor(gDat)
png(filename="figure/HeatmapYrCor.png")
heatmap.2(gDatCor, col = gBuPuFun, trace = "none", 
          main = "Heatmap of Correlation among Years")
dev.off()

## find the two years with least correlation and plot their curve
min(gDatCor) 
minrow <- which.min(gDatCor) %/% nrow(gDatCor) + 1
mincol <- which.min(gDatCor) %% nrow(gDatCor)
gDatCor[minrow, mincol] == min(gDatCor)
(year1 <- as.numeric(substr(rownames(gDatCor)[minrow], 6, 9)))
(year2 <- as.numeric(substr(colnames(gDatCor)[mincol], 6, 9)))

## plot the trend for these two years
gDat <- ddply(jDat, ~ Year + Month, function(x) c(TotalFire = length(x$Year)))
## The tow years are plotted with red and blue, others are grey
PickYr <- range(minrow, mincol)
gColors <- rep(c("grey", "deeppink", "grey", "red", "grey"), 
               c(PickYr[1]-1, 1, PickYr[2]-PickYr[1]-1, 1, nrow(gDatCor)-PickYr[2]))
names(gColors) <- sort(unique(gDat$Year))

ggplot(gDat, aes(x = Month, y = TotalFire, color = factor(Year))) + 
  geom_point() + geom_line() + theme_bw() + 
  scale_color_manual(values = gColors) +
  ggtitle(paste0("Total Number of Fire over Month in year ", year2, ", ", year1)) +
  guides(color = FALSE) 

ggsave(filename="figure/FireSizeMonTrd.png")
dev.off()

#### Which Province Fluctuate the most over years?
gDat <- ddply(jDat, ~ Year + Province + Cause, function(x) c(TotalFire = length(x$Year)))
gColors <- brewer.pal(n = nlevels(gDat$Cause), name = "Dark2")
names(gColors) <- sort(levels(gDat$Cause))

ggplot(gDat, aes(x = Year, y = TotalFire, color = Cause)) + 
  geom_point() + geom_line() + theme_bw() + 
  facet_wrap(~ Province, nrow=4) + 
  scale_color_manual(values = gColors) +
  ggtitle("Total Number of Large Fire over Year in Different Provinces")
ggsave(filename="figure/TotalFirePerYrProCau.png")
dev.off()

## Use spline curvature as a measurement of fluctuation
source("code/SplineCurv.R")

gDat <- read.table("data/TotalFirePerYrProCau.tsv", header=T)
## reorder the levels of Province: From West to East and from South to North
ProLevels <- c("BC", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "NL", "YT", "NT")
gDat <- arrange(transform(gDat, Province = factor(Province, levels = ProLevels)), Province)
## exlude  province of "NB", "NS" and cause of "UNK"
hDat <- droplevels(subset(gDat, Cause != "UNK" & ! Province %in% c("NB", "NS")))
str(hDat)

hDat <- daply(hDat, ~ Province + Cause, function(x) 
  {my.spline(x$Year, x$TotalFire)/length(x$Year)})
hDat <- as.data.frame(hDat, include.rownames = T)
hDat <- hDat[with(hDat, order(-LTG)), ]



