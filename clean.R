## dropColumns removes columns that are determined to be unecessary.
dropColumns <- function(list, data) {

  drop <- list

  return(data[,!(names(data) %in% drop)])

}

## tabRemoval removes errant tabs found at the end of line of some BLS data files
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

## rowRemoval
dropOldBase <- function(data) {

  data <- data[!grepl("(base)$",data$item_name),]

}


