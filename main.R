#
# main.R
# Author: tmay
#

### Initialization
## Set the working directory
setwd("~/cpi_tables")

## Load required scripts from workflow
required.scripts <- c('reader.R','clean.R','api_loader.R','error.R')
sapply(required.scripts, source, .GlobalEnv)

## Load required libraries
library(jsonlite)

blsFiles <- c('area','item','series','periodicity')

downloadBls(blsFiles)

for(data in blsFiles) {
  assign(data,readBls(data))
}

## Remove unecessary columns from cu.series
seriesDrop <- c('begin_year','begin_period','end_year','end_period','footnote_codes')
series <- dropColumns(seriesDrop, series)

blsItemSeries <- merge(series,item,by='item_code',all.x=T)

## Remove rows of series that use the old baseline for CPI inflation from cu.series file
blsItemSeries <- blsItemSeries[!grepl("(base)$",blsItemSeries$item_name),]

blsAreaSeries <- merge(blsItemSeries,area,by='area_code')#,all.x=T)
