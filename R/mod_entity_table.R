#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_entity_table_ui <- function(id) {
  ns <- NS(id)
  tabPanel(
    id,
    DT::DTOutput(ns("table1")),
    fluidRow(
      column(8),
      column(2, actionButton(ns("page_back"), "Back")),
      column(2, actionButton(ns("page_forw"), "Next"))
    ),
    fluidRow(
      column(9, actionButton(ns("back"), "Scope out"))
    ),
    helpText("Ask for more help when required.")
  )
}

#' table Server Functions
#'
#' @noRd
mod_entity_table_server <- function(id, request) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    response <- reactiveValues(direction = NULL, val = NULL, initial_url = NULL)

    query <- reactive({
      "$top=10"
    })

    data_data <- reactive({
      req(nchar(request$endpoint) > 0)
      d <- detailed_get(request$endpoint, request$entity, query = query())
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
          paging = FALSE,
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

    return(response)
  })
}
