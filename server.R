library(shiny)

source("quiz_db.R")

if (!create_database()) {
  cat("Unable to create database\n", file=stderr());
}

shinyServer(function(input, output, session) {

  v <- reactiveValues(scores = read_samples())

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
    par(mar=c(3,3,3,0))
    hist(v$scores$score, main="Score", xaxs="i")
    abline(v=input$score, col="red")
  } )

  output$bonus <- renderPlot( {
    par(mar=c(3,3,3,0))
    hist(v$scores$bonus, main="Bonus", xaxs="i")
    abline(v=input$bonus, col="red")
  } )

  output$total <- renderPlot( {
    par(mar=c(3,3,3,0))
    hist(v$scores$bonus + v$scores$score, main="Total score", xaxs="i")
    abline(v=input$bonus+input$score, col="red")
  } )

  output$score_bonus <- renderPlot( {
    par(mar=c(3,3,3,0))
    plot(score ~ bonus, data=v$scores, pch=19, col="grey50")
    points(input$bonus, input$score, col="red")
  } )

})
