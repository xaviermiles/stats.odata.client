#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_endpoint_table_ui <- function(id) {
  ns <- NS(id)
  tabPanel(
    id,
    DT::DTOutput(ns("table1")),
    fluidRow(
      column(9, actionButton(ns("back"), "Scope out")),
      column(3, actionButton(ns("forward"), "Scope in"))
    ),
    helpText("Ask for more help when required.")
  )
}

#' table Server Functions
#'
#' @noRd
mod_endpoint_table_server <- function(id, request) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    response <- reactiveValues(direction = NULL, val = NULL, initial_url = NULL)

    data_data <- reactive({
      req(nchar(request$endpoint) > 0)
      d <- detailed_get(request$endpoint, "")
      response$initial_url <- d$initial_url
      d$value
    })

    output$table1 <- DT::renderDT({
      tooltip_js <- includeHTML(app_sys("app/www/tooltip-on-hover.js"))

      DT::datatable(
        data_data(),
        selection = "single",
        class = "nowrap",  # stops row heights from growing
        rownames = FALSE,
        options = list(
          scrollX = TRUE,
          lengthChange = FALSE,
          columnDefs = list(
            list(
              targets = "_all",
              render = DT::JS(tooltip_js)
            )
          )
        )
      )
    })

    observeEvent(input$back, {
      response$direction <- "back"
      response$val <- ""
    })

    observeEvent(input$forward, {
      if (!is.null(input$table1_rows_selected)) {
        response$direction <- "forward"
        response$val <- data_data()$name[input$table1_rows_selected]
      }
    })

    return(response)
  })
}
