
filter <- function(data, frequency, adjustment) {

  data <- data[data[,4] == adjustment & data[,5] == frequency & data[,9] <= 3,]

  data <- data[order(data$sort_sequence.x),]

  return(data[order(data$sort_sequence.y),])

}

regionFilter <- function(area) {

# for(item in area$area_name) { print(as.character(item))}
  data <- data[grepl("(base)$",data$item_name),]

}