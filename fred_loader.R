fred_series <- read.csv('data/fred_series.csv')
fred_series <- fred_series[with(fred_series, order(series_id)),]

# areas <- as.array(as.character(unique(area$area_name)))
#
# for (place in areas) {
#   if (place != 'U.S. city average') {
#     assign(place,fred_series[grepl(paste('(',place,')',sep=""),fred_series$title),])
#   } else if (place == 'U.S. city average') {
#     assign(place,fred_series[!grepl('in',fred_series$title),])
#   }
# }

## Establish which fields to drop after tables are created
drop <- c('series_id.y','title','seasonal.x','seasonal.y','frequency','area_code','item_code','seasonal.y','periodicity_code','base_code','base_period','sort_sequence.x','display_level.y','sort_sequence.y','title.y','title.x')

## Make titles case insensitive for merger
fred_series$title <- gsub('\\&','and', fred_series$title)
fred_series$title <- toupper(fred_series$title)
fred_series$series_id <- toupper((fred_series$series_id))

## filter fred series by seasonality and frequency
fredSeriesMonthNonSeason <- fredFilter(fred_series,'R','U')
fredSeriesMonthSeason <- fredFilter(fred_series,'R','S')
fredSeriesSemiNonSeason <- fredFilter(fred_series,'S','U')
fredSeriesAnnual <- fredFilter(fred_series,'A','U')

## Handle Seasonally Adjusted, Monthly US Series
seasonalUSmonth$title <- toupper(seasonalUSmonth$title)
seasonalUSmonth <- merge(fredSeriesMonthSeason,seasonalUSmonth,by='title',all.x=T)
seasonalUSmonth <- seasonalUSmonth[with(seasonalUSmonth, order(sort_sequence.x)),]
seasonalUSmonth <- dropColumns(drop,seasonalUSmonth)
write.table(seasonalUSmonth,'template.csv',append=T,sep=",",row.names=F)

## Handle Unadjusted, Monthly US Series
nonseasonalUSmonth$title <- toupper(nonseasonalUSmonth$title)
nonseasonalUSmonth <- merge(fredSeriesMonthNonSeason,nonseasonalUSmonth,by='title')
nonseasonalUSmonth <- nonseasonalUSmonth[with(nonseasonalUSmonth, order(sort_sequence.x)),]
nonseasonalUSmonth <- dropColumns(drop,nonseasonalUSmonth)
write.table(nonseasonalUSmonth,'template2.csv',append=T,sep=",",row.names=F)

## Handle Unadjusted, Semiannual US series
nonseasonalUSSemi$title <- toupper(nonseasonalUSSemi$title)
nonseasonalUSSemi <- merge(fredSeriesMonthNonSeason,nonseasonalUSSemi,by='title')
nonseasonalUSSemi <- nonseasonalUSSemi[with(nonseasonalUSSemi, order(sort_sequence.x)),]
nonseasonalUSSemi <- nonseasonalUSSemi[with(nonseasonalUSSemi, order(sort_sequence.y)),]
nonseasonalUSSemi <- dropColumns(drop,nonseasonalUSSemi)
write.table(nonseasonalUSSemi,'template3.csv',append=T,sep=",",row.names=F)

## Handle Unadjusted, Monthly MSA series
nonseasonalMonthly$title <- toupper(nonseasonalMonthly$title)
nonseasonalMonthly <- merge(fredSeriesMonthNonSeason,nonseasonalMonthly,by='title')
nonseasonalMonthly <- nonseasonalMonthly[with(nonseasonalMonthly, order(sort_sequence.x)),]
nonseasonalMonthly <- nonseasonalMonthly[with(nonseasonalMonthly, order(sort_sequence.y)),]
nonseasonalMonthly <- dropColumns(drop,nonseasonalMonthly)
write.table(nonseasonalMonthly,'template4.csv',append=T,sep=",",row.names=F)

## Handle Unadjusted, Semiannual MSA series
nonseasonalSemi$series_id <- toupper(as.character(nonseasonalSemi$series_id))
nonseasonalSemi$series_id <- gsub('(\\s+$)','',nonseasonalSemi$series_id)
nonseasonalSemi <- merge(fredSeriesSemiNonSeason,nonseasonalSemi,by="series_id")
nonseasonalSemi <- nonseasonalSemi[with(nonseasonalSemi, order(sort_sequence.x)),]
nonseasonalSemi <- nonseasonalSemi[with(nonseasonalSemi, order(sort_sequence.y)),]
nonseasonalSemi <- dropColumns(drop,nonseasonalSemi)
write.table(nonseasonalSemi,'template5.csv',append=T,sep=",",row.names=F)

## Try to handle Annual MSA series
nonseasonalMonthly$title <- toupper(nonseasonalMonthly$title)
Annual <- merge(fredSeriesAnnual,nonseasonalMonthly,by='title',all.y=T)
Annual <- Annual[with(Annual, order(sort_sequence.x)),]
Annual <- Annual[with(Annual, order(sort_sequence.y)),]
Annual <- dropColumns(drop,Annual)








