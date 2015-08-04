library(shiny)

shinyUI(fluidPage(
  titlePanel("Quizzing with Confidence"),
  fluidRow(
    column(width=3, plotOutput("score")),
    column(width=3, plotOutput("bonus")),
    column(width=3, plotOutput("total")),
    column(width=3, plotOutput("score_bonus"))
  ),
  wellPanel(
    fluidRow(
      column(width=3, numericInput("score", "Score", value=0, min=-250, max=250, step=1)),
      column(width=3, numericInput("bonus", "Bonus", value=0, min=0, max=125, step=1)),
      column(width=3, actionButton("submit", "Submit"))
    )
  )
))
