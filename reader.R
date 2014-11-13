##  downloadBls() function takes a list of BLS data files and, iff they don't
##  exist, saves them to the data directory (which is created iff it doesn't
##  exist). Any cleaning is also carried out during this function.
downloadBls <- function(list) {
    path <- normalizePath('data')

    if (!file.exists(path)) {

      dir.create(path)

    } else if (file.exists(path)) {

      #continue

    } else {

      error()

    }

  for (text in list) {

    destination <- paste(path,text,sep="/")

    fileExistsMsg <- paste("File:",destination,"already exists. Continuing ...",
                           sep=" ")

    if (!file.exists(destination)) {

      download.file(paste('http://download.bls.gov/pub/time.series/cu/cu',text,
                          sep="."),destfile = destination)

      tabRemoval(destination)

    } else if (file.exists(destination)) {

      print(fileExistsMsg)

    } else {

      error()

    }
  }

}

##  readBls() function takes a cleaned and locally stored bls descriptive file
## title (i.e. 'series', 'item', &tc) and returns that file in a readable, tab
## delimited format.
readBls <- function(bls_file) {
 return(read.table(paste('data',bls_file,sep="/"),header=TRUE,fill=TRUE,
                   quote = "",sep="\t"))
}