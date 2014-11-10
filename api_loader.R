#   api_loader.R loads all URL information to call series information from the FRED API.
#   Improve documentation universality, and naming conventions.
#

## Base url setters and getters
set.BaseURL <- function() {

  return("http://api.stlouisfed.org/fred")

}

get.BaseURL <- function() {

  return(set.BaseURL())

}


## Series directory setter and getter
set.Dir <- function() {

  return('release')

}

get.Dir <- function() {

  return(set.Dir())

}

##Type, i.e. 'observations', setter and getter
set.Type <- function() {

  return('series')

}

get.Type <- function() {

  return(set.Type())

}


get.Units <- function() {

  return(set.Units())

}

## File type setter and getter
set.fileType <- function() {

  base <- "file_type"
  type <- "json"
  return(paste(base,type,sep="="))

}

get.fileType <- function() {

  return(set.fileType())

}

## API key setter and getter
set.APIKey <- function() {

  base <- "api_key"
  key <- "76bb1186e704598b725af0a27159fdfc"
  return(paste(base,key,sep="="))

}

get.APIKey <- function() {

  return(set.APIKey())

}

## Directory url setter and getter <<- http://api.stlouisfed.org/fred/release
set.dirURL <- function() {

  base <- get.BaseURL()
  dir <- get.Dir()

  return(paste(base,dir,sep="/"))
}

get.dirURL <- function() {

  return(set.dirURL())

}

## Type url setter and getter <<- http://api.stlouisfed.org/fred/release/series
set.typeURL <- function() {

  base <- get.dirURL()
  type <- get.Type()

  return(paste(base,type,sep="/"))

}

get.typeURL <- function() {

  return(set.typeURL())

}

## Url to pull series observations
set.finalURL<- function() {

  base <- get.typeURL()
  key <- get.APIKey()
  api <- paste(base,key,sep="?")
  file.type <- get.fileType()
  url <- paste(api,file.type,sep="&")

  return(url)

}

get.finalURL <- function() {

  return(set.finalURL())

}

get.JSON <- function(id) {

  base<- get.finalURL()
  series<- paste(base,'&release_id=',id,sep="")

  # Get json from url. Error out if url is not successful.
  if (url_success(series) == TRUE) {

    return(fromJSON(series))

  } else if (url_success(series) == FALSE) {

    print("There was an issue when calling the API. Please check that the series id is correct.")
    # Insert error trapping
    stop()

  } else {

    return("something has gone awry horribly. turn back, now.")
    stop()
  }

}

## Convert JSON file to data frame and scale values
get.data <- function(object) {

  # Convert JSON object to data frame for processing
  data <- data.frame(object$observations)

  # Drop realtime start and end
  keeps <- c("series_id","title")
  data <- data[(names(data) %in% keeps)]


  return(data)

  ###########################################################################################
  ##### The data frame should be immutable at this point! Do not attempt to change it! ######
  ###########################################################################################
}