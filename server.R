library(shiny)

source("quiz_db.R")

if (!create_database()) {
  cat("Unable to create database\n", file=stderr());
}

shinyServer(function(input, output, session) {

  v <- reactiveValues(scores = read_scores())

  # make the submit button do something useful
  observeEvent(input$submit, {
    cat("button hit\n")

    if (input$bonus > 0) {
      # write the results to the database
      v$scores <- rbind(v$scores, c(input$score, input$bonus))
      if (!write_sample(input$score, input$bonus)) {
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
    hist(v$scores$score, main="Score", xlim=range(v$scores$score, input$score, na.rm=TRUE), xaxs="i", col="grey60", xlab="")
    abline(v=input$score, lwd=2)
  } )

  output$bonus <- renderPlot( {
    par(mar=c(4,4,3,0))
    hist(v$scores$bonus, xlim=range(v$scores$bonus, input$bonus, na.rm=TRUE), main="Bonus", xaxs="i", col="pink", xlab="")
    abline(v=input$bonus, lwd=2)
  } )

  output$total <- renderPlot( {
    par(mar=c(4,4,3,0))
    xlim <- range(v$scores$bonus + v$scores$score, input$bonus+input$score, na.rm=TRUE)
    hist(v$scores$bonus + v$scores$score, xlim=xlim, main="Total score", xaxs="i", col="lightblue", xlab="")
    abline(v=input$bonus+input$score, lwd=2)
  } )

  output$score_bonus <- renderPlot( {
    par(mar=c(4,4,3,0))
    plot(score ~ bonus, data=rbind(v$scores, c(input$score, input$bonus)), pch=19, col="grey50", xlab="Bonus", ylab="Score", main="Score versus Bonus", bty="n")
    points(input$bonus, input$score, col="red", pch=19)
  } )

})
