#
# clean.R contains all functions that are used for cleaning data sets.
# Author: Travis May
#

## dropColumns() removes columns that are determined to be unecessary.
dropColumns <- function(list, data) {

  drop <- list

  return(data[,!(names(data) %in% drop)])

}

## tabRemoval() removes trailing tabs from lines in some BLS data files. Only operates if trailing tabs exist.
tabRemoval <- function(file) {

  tabCheck <- grepl("(\\t)$",readLines(file)[2])

  if ( tabCheck == TRUE) {

    conn <- readLines(file)
    newConn <- file

    for (line in conn) {
      newLine <- sub("(\\t)$","",conn)
      writeLines(newLine,con = newConn,sep="\n")
    }

  } else if (tabCheck == FALSE) {
    #next
  } else {
    error()
  }
}

## dropOldBase() removes rows of data series that use old base periods as units.
dropOldBase <- function(data) {

  data <- data[!grepl("(base)$",data$item_name),]

}


