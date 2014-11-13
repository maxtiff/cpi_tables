fred_series <- read.csv('data/fred_series.csv')
fred_series <- fred_series[with(fred_series, order(series_id)),]

areas <- as.array(as.character(unique(area$area_name)))

for (item in areas) {
  if (item != 'U.S. city average') {
    assign(item,fred_series[grepl(paste('(',item,')',sep=""),fred_series$title),])
  } else if (item == 'U.S. city average') {
    assign(item,fred_series[!grepl('in',fred_series$title),])
  }
}

test <- merge(fred_series,us,by='title',all.y=T,)