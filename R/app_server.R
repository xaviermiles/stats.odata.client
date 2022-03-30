#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  reset_response <- function(resp) resp$direction <- NULL

  # Main objects ---------------------------------------------------------------
  request <- reactiveValues(endpoint = "", entity = "", query = "$top=10")

  resp_catalogue <- mod_catalogue_server("catalogue_1")
  resp_endpoint <- mod_table_server("endpoint_view", data_data)
  resp_entity <- mod_table_server("entity_view", data_data, buttons = c("back"))

  # Observe and update `request` -----------------------------------------------
  observeEvent(resp_catalogue$val, {
    req(is.character(resp_catalogue$val))
    request$endpoint <- resp_catalogue$val
  })

  observeEvent(resp_endpoint$val, {
    req(is.character(resp_endpoint$val))
    request$entity <- resp_endpoint$val
  })

  data_data <- reactive({
    req(nchar(request$endpoint) > 0)
    if (request$entity == "")
      detailed_get(request$endpoint, request$entity, query = request$query)
    else
      detailed_parallel_get(request$endpoint, request$entity, query = request$query)
  })

  output$footer_text <- renderText({
    if (request$endpoint == "")
      url <- build_basic_url('data.json')  # catalogue
    else
      url <- data_data()$initial_url

    glue("Get this info: {url}")
  })

  # Handle direction -----------------------------------------------------------
  observeEvent(resp_catalogue$direction, {
    req(!is.null(resp_catalogue$direction))

    if (resp_catalogue$direction == "forward") {
      appendTab("main_panel", mod_table_ui("endpoint_view"), select = TRUE)
    }

    reset_response(resp_catalogue)
  })

  observeEvent(resp_endpoint$direction, {
    req(!is.null(resp_endpoint$direction))

    if (resp_endpoint$direction == "forward") {
      appendTab("main_panel", mod_table_ui("entity_view"), select = TRUE)
    } else if (resp_endpoint$direction == "back") {
      resp_catalogue$val <- ""
      updateTabsetPanel(session, "main_panel", selected = "catalogue")
      removeTab("main_panel", target = "endpoint_view")
    }

    reset_response(resp_endpoint)
  })

  observeEvent(resp_entity$direction, {
    req(!is.null(resp_entity$direction))

    if (resp_entity$direction == "back") {
      resp_endpoint$val <- ""
      updateTabsetPanel(session, "main_panel", selected = "endpoint_view")
      removeTab("main_panel", target = "entity_view")
    }

    reset_response(resp_entity)
  })
}
