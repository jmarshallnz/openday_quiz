library(shiny)

inlineNumeric<-function (inputId, label, value = 0, min = NULL, max = NULL, step = NULL, width=NULL, color=NULL) 
{
  style = "display:inline-block;"
  if (!is.null(width)) style = paste0(style, "max-width: ", width, ";")
  text_style = NULL
  if (!is.null(color)) text_style = paste0("background-color: ", color, ";")
  div(class="form-group shiny-input-container",
      style=style,
      tags$label(label, `for` = inputId),
      tags$input(id = inputId, type="number", class="form-control", value = value, min=min, max=max, step=step, style=text_style))
}

shinyUI(fluidPage(
  titlePanel("Quizzing with Confidence"),
  fluidRow(
    column(width=3, plotOutput("score")),
    column(width=3, plotOutput("bonus")),
    column(width=3, plotOutput("total")),
    column(width=3, plotOutput("score_bonus"))
  ),
  wellPanel(
    inlineNumeric("score", "Score", value=0, min=-250, max=250, step=1, width='150px'),
    inlineNumeric("bonus", "Bonus", value=0, min=0, max=125, step=1, width='150px'),
    actionButton("submit", "Submit")
  )
))
