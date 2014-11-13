
filter <- function(data, frequency, adjustment) {

  data <- data[data[,4] == adjustment & data[,5] == frequency,]

  data <- data[order(data$sort_sequence.x),]

  return(data[order(data$sort_sequence.y),])

}

areaFilter <- function(data) {


  # data <- data[grepl("(base)$",data$area_name),]
  areas <- as.array(as.character(unique(data$area_code)))
  fileName <-
  for(item in areas) {
    print(item)

    suppressWarnings(write.table(assign(item,data.frame(data[grepl(item,data$area_code),])),'data/test.csv',append=TRUE,sep=","))
  }

}

areaFilter(nonseasonalSemi)
