#
# main.R contains the complete, scripted process.
#

### Initialization
## Set the working directory
# workingDir <- normalizePath('..\\cpi_tables')
# setwd(workingDir)

## Load required libraries
library(jsonlite)
library(httr)
library(XML)

## Load required scripts from workflow
required.scripts <- c('reader.R','clean.R','api_loader.R','error.R','filter.R')
sapply(required.scripts, source, .GlobalEnv)

blsFiles <- c('area','item','series','periodicity')

## Download files from source
downloadBls(blsFiles)

## Read files into data tables for manipulation.
for(data in blsFiles) {
  assign(data,readBls(data))
}

## Remove unnecessary columns from 'series' table
seriesDrop <- c('begin_year','begin_period','end_year','end_period','footnote_codes')
series <- dropColumns(seriesDrop, series)

## Remove unnecessary columns from 'area' table
areaDrop <- c('selectable')
area <- dropColumns(areaDrop,area)

## Remove unnecessary columns from 'item' table
itemDrop <-c('selectable')
item <- dropColumns(itemDrop,item)


## Merge 'series' and 'item' tables by item_code.
mergedItemSeries <- merge(series,item,by='item_code',all.x=T)

## Remove rows of series that use the old baseline for CPI inflation from
## cu.series file
mergedItemSeries <- dropOldBase(mergedItemSeries)

## Merge 'area' with previously merged 'item' and 'series' tables.
mergedAreaSeries <- merge(mergedItemSeries,area,by='area_code',all.x=T)

# if(!grepl('U.S. city average',mergedAreaSeries$area_name)) {
#   mergedAreaSeries$title <- paste('Consumer Price Index for All Urban Consumers:',mergedAreaSeries[,8],'in',mergedAreaSeries[,11],sep=" ")
# } else {
#   mergedAreaSeries$title <- paste('Consumer Price Index for All Urban Consumers:',mergedAreaSeries[,8], sep=" ")
# }

## Serpate US City Average for processing
us <- mergedAreaSeries[grepl('U.S. city average',mergedAreaSeries$area_name),]
us$title <- paste('Consumer Price Index for All Urban Consumers:',us[,8], sep=" ")
mergedAreaSeries<- mergedAreaSeries[!grepl('U.S. city average',mergedAreaSeries$area_name),]

## Create Seasonally Adjusted Monthly Table -- US only
seasonalMonthlyUS <- filter(us,'R','S')

## Create Unadjusted Monthly and US only table
nonseasonalMonthly <- filter(mergedAreaSeries,'R','U')
nonseasonalMonthlyUS <- filter(us,'R','U')

## Create Unadjusted Semiannual Table
nonseasonalSemi <- filter(mergedAreaSeries,'S','U')
nonseasonalSemiUS <- filter(us,'S','U')


areaFilter(nonseasonalSemi)
areaFilter(nonseasonalMonthly)
areaFilter(seasonalMonthly)


fred_series <- read.csv('data/fred_series.csv')
fred_series <- fred_series[with(fred_series, order(series_id)),]