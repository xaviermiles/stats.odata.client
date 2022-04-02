#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  reset_response <- function(resp) resp$direction <- NULL

  # Main objects ---------------------------------------------------------------
  request <- reactiveValues(endpoint = "", entity = "")

  resp_catalogue <- mod_catalogue_server("catalogue1")
  resp_endpoint <- mod_endpoint_table_server("endpoint1", request)
  resp_entity <- mod_entity_table_server("entity1", request)

  # Observe and update `request` -----------------------------------------------
  observeEvent(resp_catalogue$val, {
    req(is.character(resp_catalogue$val))
    request$endpoint <- resp_catalogue$val
  })

  observeEvent(resp_endpoint$val, {
    req(is.character(resp_endpoint$val))
    request$entity <- resp_endpoint$val
  })

  output$footer_text <- renderText({
    if (input$main_panel == "catalogue")
      url <- build_basic_url('data.json')
    else if (is.character(resp_entity$initial_url))
      url <- resp_entity$initial_url
    else if (is.character(resp_endpoint$initial_url))
      url <- resp_endpoint$initial_url
    else
      url <- ""

    glue("Get this info: {url}")
  })

  # Handle direction -----------------------------------------------------------
  observeEvent(resp_catalogue$direction, {
    req(!is.null(resp_catalogue$direction))

    if (resp_catalogue$direction == "forward") {
      appendTab("main_panel", mod_endpoint_table_ui("endpoint1"), select = TRUE)
    }

    reset_response(resp_catalogue)
  })

  observeEvent(resp_endpoint$direction, {
    req(!is.null(resp_endpoint$direction))

    if (resp_endpoint$direction == "forward") {
      appendTab("main_panel", mod_entity_table_ui("entity1"), select = TRUE)
    } else if (resp_endpoint$direction == "back") {
      resp_catalogue$val <- ""
      updateTabsetPanel(session, "main_panel", selected = "catalogue")
      removeTab("main_panel", target = "endpoint1")
    }

    reset_response(resp_endpoint)
  })

  observeEvent(resp_entity$direction, {
    req(!is.null(resp_entity$direction))

    if (resp_entity$direction == "back") {
      resp_endpoint$val <- ""
      updateTabsetPanel(session, "main_panel", selected = "endpoint1")
      removeTab("main_panel", target = "entity1")
    }

    reset_response(resp_entity)
  })
}
