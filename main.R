#
# main.R contains the complete, scripted process.
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

## Download files from source
downloadBls(blsFiles)

## Read files into data tables for manipulation.
for(data in blsFiles) {
  assign(data,readBls(data))
}

## Remove unnecessary columns from cu.series
seriesDrop <- c('begin_year','begin_period','end_year','end_period','footnote_codes')
series <- dropColumns(seriesDrop, series)

## Remove unnecessary columns from 'area' table
areaDrop <- c('selectable')
area <- dropColumns(areaDrop,area)

## Merge 'series' and 'item' tables by item_code.
mergedItemSeries <- merge(series,item,by='item_code',all.x=T)

## Remove rows of series that use the old baseline for CPI inflation from cu.series file
mergedItemSeries <- dropOldBase(mergedItemSeries) #[!grepl("(base)$",blsItemSeries$item_name),]

## Merge 'area' with previously merged 'item' and 'series' tables.
mergedAreaSeries <- merge(mergedItemSeries,area,by='area_code')#,all.x=T)
