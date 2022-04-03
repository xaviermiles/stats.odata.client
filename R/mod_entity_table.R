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
      column(8, textOutput(ns("page_status"))),
      column(2, actionButton(ns("page_back"), "Back")),
      column(2, actionButton(ns("page_forw"), "Next")),
      style = "padding-top:1vh; padding-bottom:1vh"
    ),
    tags$h2("Extra special queries"),
    uiOutput(ns("query_rows")),
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

    # Core ---------------------------------------------------------------------
    response <- reactiveValues(direction = NULL, val = NULL, initial_url = NULL)
    min_row <- reactiveVal(value = 1)

    full_count <- reactive({
      req(nchar(request$endpoint) > 0)
      basic_get(request$endpoint, request$entity, query = "$apply=aggregate($count as count)")[1, 1]
    })

    query <- reactive({
      skip <- min_row() - 1
      glue(
        "$top=10",
        if (skip > 0) glue("&$skip={skip}") else ""
      )
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
          info = FALSE,
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

    # Paging dataset -----------------------------------------------------------
    observeEvent(request$entity, {
      min_row(1) # reset when new entity is opened
    })
    observeEvent(input$page_back, {
      new <- min_row() - 10
      if (new >= 1)
        min_row(new)
    })
    observeEvent(input$page_forw, {
      req(is.numeric(full_count()))
      new <- min_row() + 10
      if (new <= full_count())
        min_row(new)
    })

    output$page_status <- reactive({
      end_row <- min(min_row() + 9, full_count())
      glue("Showing {min_row()} to {end_row} of {full_count()} entries")
    })

    observeEvent(input$back, {
      response$direction <- "back"
      response$val <- ""
    })

    # Extra special queries ----------------------------------------------------
    output$query_rows <- renderUI({
      get_query_row(glue("{request$entity}_arrange1"))
    })

    # Only supports "arrange" currently, but structure/UI is designed to be
    # extendable to filter, select etc
    get_query_row <- function(id) {
      fluidRow(
        column(3,
          selectInput(
            ns(glue("{id}_verb")), "",
            choices = c("arrange")
          ),
        ),
        column(3,
          uiOutput(ns(glue("{id}_operator")))
        ),
        column(6,
          selectizeInput(
            ns(glue("{id}_val")), "",
            choices = colnames(data_data()),
            selected = input[[glue("{id}_val")]], # so choice is not reset when data_data() is regenerated
            # options = list(plugins = list("remove_button", "drag_drop")),
            multiple = TRUE
          )
        )
      )
    }

    return(response)
  })
}
