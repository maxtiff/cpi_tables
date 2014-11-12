
filter <- function(data, frequency, adjustment) {

  data <- data[data[,4] == adjustment & data[,5] == frequency & data[,9] <= 3,]

  return(data[order(data$sort_sequence.x),])

}