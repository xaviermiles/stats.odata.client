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
      tooltip_js <- includeHTML(app_sys("app/www/tooltip-on-hover.js"))

      DT::datatable(
        data_data()$value,
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
      response$val <- NULL
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
    })

    return(response)
  })
}
