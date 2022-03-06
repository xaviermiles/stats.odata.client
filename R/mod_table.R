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
    id,
    DT::DTOutput(ns("table1")),
    fluidRow(
      column(9, actionButton(ns("back"), "Scope out")),
      column(3, uiOutput(ns("potential_forward")))
    ),
    helpText("Ask for more help when required.")
  )
}

#' table Server Functions
#'
#' @noRd
mod_table_server <- function(id, data_data, buttons = c("back", "forward")) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    response <- reactiveValues(direction = NULL, val = NULL)

    output$table1 <- DT::renderDT({
      DT::datatable(
        data_data()$value,
        selection = "single",
        options = list(
          lengthChange = FALSE
        )
      )
    })

    observeEvent(input$back, {
      response$direction <- "back"
      response$val <- NULL
      print("back")
    })

    output$potential_forward <- renderUI({
      if (!"forward" %in% buttons)
        return(HTML(NULL))

      actionButton(ns("forward"), "Scope in")
    })

    observeEvent(input$forward, {
      if (!is.null(input$table1_rows_selected)) {
        response$direction <- "forward"
        response$val <- data_data()$value$name[input$table1_rows_selected]
      }
      print("forward")
    })

    return(response)
  })
}

## To be copied in the UI
# mod_table_ui("table_ui_1")

## To be copied in the server
# mod_table_server("table_ui_1")
