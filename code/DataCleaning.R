## set working directory 
##setwd("~/Statistics/stat545A/Final Project")

## import data 
# row 4090: "BILL'S" ----> use quot="\"" when importing data
# some rows: have "#" in "Fire_ID" ----> use comment.char="" when importing data
rDat <- read.table("data/LFD_A02_5999_e.txt", sep=",", quot="\"", header=T, comment.char="")
str(rDat)  # 11231 rows & 16 columns


## choose variables of interest
colnames(rDat)
InterestVar <- c("Year", "Month", "Day", "Province", "Latitude", "Longitude", "Cause", "Size")
gDat <- subset(rDat, select = InterestVar)
str(gDat)  # 11231 rows & 8 columns


## drop levels of of some variables
sum(gDat$Cause =="MAN-PB") # 37
# Note: There are only 3 levels of Cause in the "Data Format" online
# But 4 in the dataset ----> combine "MAN-PB" and "Man" together 
gDat[which(gDat$Cause =="MAN-PB"), "Cause"] <- "MAN"
# drop level of "MAN-PB" from "Cause"
gDat <- droplevels(subset(gDat, Cause != "MAN-PB"))
str(gDat)  # 11231 rows & 8 columns
TotalRow <- nrow(gDat)


## check percentage of missing value for each variable
# Year 
(MissYear <- sum(is.na(gDat$Year)))
(PerYear <- MissYear / TotalRow)
# Month: entry for missing data = 0
(MissMonth <- sum(gDat$Month == 0))
(PerMonth <- MissMonth / TotalRow)
# Day: entry for missing data = 0
(MissDay <- sum(gDat$Day == 0))
(PerDay <- MissDay / TotalRow)
# Province
(MissPro <- sum(is.na(gDat$Province)))
(PerPro <- MissPro / TotalRow)
# Latitude: entry for missing data = 0
(MissLat <- sum(gDat$Latitude == 0))
(PerLat <- MissLat / TotalRow)
# Longitude: entry for missing data = 0
(MissLon <- sum(gDat$Longitude == 0))
(PerLon <- MissLon / TotalRow)
# Cause: entry for missing data = "UNK"
(MissCause <- TotalRow - sum(gDat$Cause != "UNK"))
(PerCause <- MissCause / TotalRow)
# Size
(MissSize <- TotalRow - length(na.omit(gDat$Size)))
(PerSize <- MissSize / TotalRow)

 
## check basic information
sort(unique(gDat$Year))
sort(unique(gDat$Month)) # No January, strange
sort(unique(gDat$Day))
(RangeLat <- range(unlist(subset(gDat, select = "Latitude", Latitude != 0))))
(RangeLon <- range(unlist(subset(gDat, select = "Longitude", Longitude != 0))))


## make the table describing data format and missing value
VarName <- colnames(gDat)
VarClass <- sapply(gDat, class)
VarDes <- c("Year of fire start: from 1959 to 1999",
            "Month of fire start (No January, strange)",
            "Day of fire start",
            "11 levels: BC, AB, SK, MB, ON, QC, NF, NB, NS, YK, NWT",
            paste0("Fire start location",", from ", round(RangeLat[1], 2), " to ", round(RangeLat[2], 2)),
            paste0("Fire start location", ", from ", RangeLon[1], " to ", RangeLon[2]),
            "3 levels: MAN (human), LTG (lightning), UNK (unknown)",
            "Final fire size in hectares")
MissEntry <- c("", "0", "0", "", "0", "0", "UNK", "")
MissNumPer <- c(sprintf("%d (%1.3f)", MissYear, PerYear),
             sprintf("%d (%1.3f)", MissMonth, PerMonth),
             sprintf("%d (%1.3f)", MissDay, PerDay),
             sprintf("%d (%1.3f)", MissPro, PerPro),
             sprintf("%d (%1.3f)", MissLat, PerLat),
             sprintf("%d (%1.3f)", MissLon, PerLon),
             sprintf("%d (%1.3f)", MissCause, PerCause),
             sprintf("%d (%1.3f)", MissSize, PerSize)
             )

DataFormat <- data.frame(Variable_Name = VarName,
                         Variable_Class = VarClass,
                         Variable_Description = VarDes,
                         Missing_Entry = MissEntry,
                         Missing_NumPer = MissNumPer)

write.table(DataFormat, file="result/DataFormat.tsv", row.names=F)

## remove all the missing value (but keep "UNK" fire)
jDat <- subset(gDat, subset = Month != 0 & Day != 0 & Latitude != 0 & Longitude != 0)
# drop levels of "WBNP" (Wood Buffalo National Park) & "NP" (National Park) from "Province"
jDat <- droplevels(subset(jDat, ! Province %in% c("WBNP", "NP")))


## use current short names for PQ(QC), NWT (NT), NF(NL) and YK(YT) (see wikipedia)
levels(jDat$Province)
levels(jDat$Province) <- c("AB", "BC", "MB", "NB", "NL", "NS", "NT", "ON", "QC", "SK", "YT")

str(jDat) # 10623 rows & 8 columns
write.table(jDat, file="data/CleanData.tsv", row.names=F)


## remove all the variables
rm(list = ls())            
            
  
                        