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
mod_table_server <- function(id, selection_info) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    selected <- reactiveVal()

    data_data <- reactive({
      d <- NULL
      if (selection_info$type == "endpoint")
        d <- basic_get(selection_info$val(), "")
      else if (selection_info$type == "entity")
        d <- basic_get(selection_info$val[[1]](), selection_info$val[[2]]())

      return(d)
    })

    output$table1 <- DT::renderDT({
      DT::datatable(data_data(), selection = "single",
                    options = list(lengthChange = FALSE))
    })

    observeEvent(input$back, {
      # TODO: how to send signal?
    })

    output$potential_forward <- renderUI({
      if (selection_info$type == "entity")
        return(HTML(NULL))

      actionButton(ns("forward"), "Scope in")
    })

    observeEvent(input$forward, {
      if (!is.null(input$table1_rows_selected)) {
        selected_name <- data_data()$name[input$table1_rows_selected]
        selected(selected_name)
      }
    })

    return(selected)
  })
}

## To be copied in the UI
# mod_table_ui("table_ui_1")

## To be copied in the server
# mod_table_server("table_ui_1")
