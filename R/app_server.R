#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  selected_endpoint <- mod_catalogue_server("catalogue_1")
  selected_entity <- mod_table_server("endpoint_view", list(val = selected_endpoint, type = "endpoint"))
  mod_table_server("entity_view", list(val = c(selected_endpoint, selected_entity), type = "entity"))

  observeEvent(selected_endpoint(), {
    if (is.null(selected_endpoint())) {
      showTab("main_panel", "catalogue")
    } else {
      appendTab("main_panel", mod_table_ui("endpoint_view"), select = TRUE)
    }
  })

  observeEvent(selected_entity(), {
    if (!is.null(selected_entity())) {
      appendTab("main_panel", mod_table_ui("entity_view"), select = TRUE)
    } else if (!is.null(selected_endpoint())) {
      # Kick back to endpoint view?
      removeTab("main_panel", "entity_view")
    }
  })
}
