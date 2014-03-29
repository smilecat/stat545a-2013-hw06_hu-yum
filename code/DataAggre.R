#setwd("~/Statistics/stat545A/Final Project")
jDat <- read.table("data/CleanData.tsv", header=T)
str(jDat)
tail(jDat)

library(plyr)   # for data aggregation

#### sort the data ----> Year + Month + Province + Day + Size
gDat <- jDat[with(jDat, order(Year, Month, Day, Province, Size)), ]
write.table(gDat, file = "data/SortData.tsv", row.names = F)

#### count total num of fire every year 
gDat <- ddply(jDat, ~ Year, function(x) c(TotalFire = length(x$Year)))
write.table(gDat, file = "data/TotalFirePerYr.tsv", row.names = F)

#### count total num of fire every year broup by Cause
gDat <- ddply(jDat, ~ Year + Cause, function(x) c(TotalFire = length(x$Year)))
write.table(gDat, file = "data/TotalFirePerYrCau.tsv", row.names = F)

#### count total num of fire every year and Province group by Cause
gDat <- ddply(jDat, ~ Year + Province + Cause, function(x) c(TotalFire = length(x$Year)))
write.table(gDat, file = "data/TotalFirePerYrProCau.tsv", row.names = F)

#### count num of fire every month in different Province group by picked Year
PickYear <- seq(from = 1959, to = 1999, by = 5)
gDat <- ddply(subset(jDat, Year %in% PickYear), ~ Year + Month, 
              function(x) c(TotalFire = length(x$Year)))
write.table(gDat, file = "data/TotalFirePerYearMon.tsv", row.names = F)

#### count num of fire per month every year
gDat <- daply(jDat, ~ Year + Month, function(x) length(x$Year))
## replace NA with 0 in the gDat
gDat[is.na(gDat)] <- 0
gDat <- as.data.frame(gDat)
colnames(gDat) <- paste0("Month ",colnames(gDat))
rownames(gDat) <- paste0("Year ", rownames(gDat))
write.table(gDat, file = "data/TotalFireByYrMon.tsv")