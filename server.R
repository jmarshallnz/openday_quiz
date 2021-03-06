library(shiny)
library(lubridate)

source("quiz_db.R")

quiz_year = lubridate::year(Sys.Date())

if (!create_database()) {
  cat("Unable to create database\n", file=stderr());
}

ext_range <- function(...) {
  r <- range(...)
  (r - mean(r))*1.05 + mean(r)
}

shinyServer(function(input, output, session) {

  v <- reactiveValues(scores = read_scores())

  # make the submit button do something useful
  observeEvent(input$submit, {
    cat("button hit\n")

    if (input$bonus > 0) {
      # write the results to the database
      v$scores <- rbind(v$scores, c(input$score, input$bonus, quiz_year))
      if (!write_sample(input$score, input$bonus, quiz_year)) {
        cat("Unable to write sample to database\n", file=stderr())
      }
    }

    # reset our input controls
    updateNumericInput(session, "score", value=0)
    updateNumericInput(session, "bonus", value=0)
  })

  # plot on the left shows actual data
  output$score <- renderPlot( {
    par(mar=c(4,4,3,0))
    hist(v$scores$score, main="Score", xlim=ext_range(v$scores$score, input$score, na.rm=TRUE), xaxs="i", col="grey60", xlab="")
    abline(v=v$scores$score[length(v$scores$score)], lwd=2, col="red")
  } )

  output$bonus <- renderPlot( {
    par(mar=c(4,4,3,0))
    hist(v$scores$bonus, xlim=ext_range(v$scores$bonus, input$bonus, na.rm=TRUE), main="Bonus", xaxs="i", col="pink", xlab="")
    abline(v=v$scores$bonus[length(v$scores$bonus)], lwd=2, col="red")
  } )

  output$total <- renderPlot( {
    par(mar=c(4,4,3,0))
    xlim <- ext_range(v$scores$bonus + v$scores$score, input$bonus+input$score, na.rm=TRUE)
    hist(v$scores$bonus + v$scores$score, xlim=xlim, main="Total score", xaxs="i", col="lightblue", xlab="")
    abline(v=v$scores$bonus[length(v$scores$bonus)]+v$scores$score[length(v$scores$score)], lwd=2, col="red")
  } )

  output$score_bonus <- renderPlot( {
    par(mar=c(4,4,3,0))
    cols <- c("grey70", "grey50")
    plot(score ~ bonus, data=v$scores, pch=19, col=cols[as.numeric(as.factor(year))], xlab="Bonus", ylab="Score", main="Score versus Bonus", bty="n")
    points(v$scores$bonus[length(v$scores$bonus)], v$scores$score[length(v$scores$score)], col="red", pch=19)
  } )

})
