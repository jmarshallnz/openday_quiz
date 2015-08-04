library(RMySQL)

# fetch from the database if possible
read_scores <- function() {
  values <- NULL

  try({
    values = read.csv("opendayquiz.csv")
  }, silent=TRUE)

  values
}

# create the database if possible
create_database <- function() {
  success <- FALSE
  
  try({
    # check if the file exists
    if (!file.exists("opendayquiz.csv")) {
      # otherwise, create it
      scores <- data.frame(score=NA, bonus=NA) 
      write.csv(scores, "opendayquiz.csv", row.names=FALSE)
    }
    success <- TRUE
  }, silent=TRUE)

  success
}

# write sample to the database if possible
write_sample <- function(score, bonus) {
  success <- FALSE

  # read in the csv
  try({
    scores <- read.csv("opendayquiz.csv")
    scores <- rbind(scores, c(score, bonus))

    write.csv(scores, "opendayquiz.csv", row.names=FALSE)

    success <- TRUE
  }, silent=TRUE)

  success
}
