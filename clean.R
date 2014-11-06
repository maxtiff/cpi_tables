## dropColumns removes columns that are determined to be unecessary.
dropColumns <- function(list, data) {

  drop <- list

  return(data[,!(names(data) %in% drop)])

}

## tabRemoval removes errant tabs found at the end of line of some BLS data files
tabRemoval <- function(file) {

  if(file != grep("^(series)")) {

    conn <- readLines(file)
    newConn <- file

    for (line in conn) {

      newLine <- sub("(\\t)$","",conn)
      writeLines(newLine,con = newConn,sep="\n")

    }
  } else {
    #next
  }
}

rowRemoval <- function(data) {

  data <- data[!grepl("(base)$",data$item_name),]

}


