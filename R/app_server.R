#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  reset_response <- function(resp) resp$direction <- NULL

  resp_catalogue <- mod_catalogue_server("catalogue_1")
  resp_endpoint <- mod_table_server("endpoint_view", data_data)
  resp_entity <- mod_table_server("entity_view", data_data, buttons = c("back"))

  selected <- reactive({
    list(
      endpoint = ifelse(!is.null(resp_catalogue$val), resp_catalogue$val, ""),
      entity = ifelse(!is.null(resp_endpoint$val), resp_endpoint$val, "")
    )
  })

  data_data <- reactive({
    # TODO: return something for catalogue so URL can still be displayed
    req(selected()$endpoint != "")
    if (selected()$entity == "")
      detailed_get(selected()$endpoint, selected()$entity)
    else
      detailed_parallel_get(selected()$endpoint, selected()$entity)
  })

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
      appendTab("main_panel", mod_table_ui("entity_view"), #target = "entity_tab", #position = "after",
                select = TRUE)
    } else if (resp_endpoint$direction == "back") {
      resp_catalogue$val <- NULL  # clear endpoint selection
      updateTabsetPanel(session, "main_panel", selected = "catalogue")
      removeTab("main_panel", target = "endpoint_view")
    }

    reset_response(resp_endpoint)
  })

  observeEvent(resp_entity$direction, {
    req(!is.null(resp_entity$direction))

    if (resp_entity$direction == "back") {
      resp_endpoint$val <- NULL  # clear entity selection
      updateTabsetPanel(session, "main_panel", selected = "endpoint_view")
      removeTab("main_panel", target = "entity_view")
    }

    reset_response(resp_entity)
  })

  output$footer_text <- renderText({
    glue::glue("Get this info: {data_data()$initial_url}")
  })
}
