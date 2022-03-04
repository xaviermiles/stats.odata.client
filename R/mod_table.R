#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_ui <- function(id) {
  ns <- NS(id)
  tabPanel(
    "Howdy",
    fluidRow(
      DT::DTOutput(ns("table")),
      helpText("Ask for more help when required.")
    )
  )
}

#' table Server Functions
#'
#' @noRd
mod_table_server <- function(id, selection_info) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    selected <- reactiveVal()

    output$table <- DT::renderDT({
      DT::datatable(data.frame(
        name = c("Johnny", "Jenny", "Jelly"),
        freckles = c(1, 12, 13),
        bikes = c(3, 4, 5)
      ))
    })

    return(selected)
  })
}

## To be copied in the UI
# mod_table_ui("table_ui_1")

## To be copied in the server
# mod_table_server("table_ui_1")
