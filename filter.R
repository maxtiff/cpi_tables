
filter <- function(data, frequency, adjustment) {

  data <- data[data[,4] == adjustment & data[,5] == frequency,]

  data <- data[order(data$sort_sequence.x),]

  return(data[order(data$sort_sequence.y),])

}

areaFilter <- function(data) {


  # data <- data[grepl("(base)$",data$area_name),]
  areas <- as.array(as.character(unique(data$area_code)))

  for(item in areas) {
    if(grepl('R', unique(data$periodicity_code)) == T & grepl('S',unique(data$seasonal)) == T) {

      fileName <- paste(item,'monthly','seasonal')
      fullPath <- paste('data/MS/',fileName,'.csv',sep="")

    } else if (grepl('R', unique(data$periodicity_code)) == T & grepl('U',unique(data$seasonal)) == T) {

      fileName <- paste(item,'monthly','nonseasonal')
      fullPath <- paste('data/MU/',fileName,'.csv',sep="")

    } else if (grepl('S', unique(data$periodicity_code)) == T & grepl('U',unique(data$seasonal)) == T) {

      fileName <- paste(item,'semiannual','nonseasonal')
      fullPath <- normalizePath(paste('data/SU/',fileName,'.csv',sep=""))

    } else {

      fileName <- paste(item)
      fullPath <- paste('data/',fileName,'.csv',sep="")

    }

    ## Remove unnecessary columns from final file.
    drop <- c('item_code','seasonal','periodicity_code','periodicity','base_code', 'base_period','sort_sequence.x','sort_sequence.y','display_level.y')
    data <- dropColumns(drop, data)
#     colnames(data)[2] <- "newname2"

    suppressWarnings(write.table(assign(item,data.frame(data[grepl(item,data$area_code),])),fullPath,append=TRUE,sep=",",row.names=FALSE))

  }

}

