library(RMySQL)

# fetch from the database if possible
read_scores <- function() {
  values <- NULL

  try({
    conn <- dbConnect(RMySQL::MySQL(), user='opendayquiz', password='opendayquiz', host='localhost', dbname='opendayquiz')

    values <- dbGetQuery(conn, "SELECT * FROM scores")[,-1]

    dbDisconnect(conn)
  }, silent=TRUE)

  values
}

# create the database if possible
create_database <- function() {
  success <- FALSE

  try({
    conn <- dbConnect(RMySQL::MySQL(), user='opendayquiz', password='opendayquiz', host='localhost', dbname='opendayquiz')

    # create score table if not already there
    fields <- "score_id INT PRIMARY KEY AUTO_INCREMENT, score INT, bonus INT, year INT"

    res <- dbSendQuery(conn, paste("CREATE TABLE IF NOT EXISTS scores (", fields, ");"))
    dbClearResult(res)

    dbDisconnect(conn)

    success <- TRUE
  }, silent=TRUE)

  success
}

# write sample to the database if possible
write_sample <- function(score, bonus, year) {
  success <- FALSE

  try({
    conn <- dbConnect(RMySQL::MySQL(), user='opendayquiz', password='opendayquiz', host='localhost', dbname='opendayquiz')

    cols <- "score,bonus,year"
    vals <- paste(c(score, bonus, year), collapse=",")
    sql  <- paste("INSERT INTO scores(",cols,") VALUES(",vals,");")

    res <- dbSendQuery(conn, sql)
    dbClearResult(res)

    dbDisconnect(conn)
    success <- TRUE
  }, silent=TRUE)

  success
}
