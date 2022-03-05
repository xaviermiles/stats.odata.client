#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),

    fluidPage(
      h1("Stats NZ Open Data API"),
      tabsetPanel(
        tabPanel(
          "catalogue",
          mod_catalogue_ui("catalogue_1")
        ),
        tabPanel(
          "hey",
          mod_table_ui("table_1")
        ),
        id = "main_panel",
        type = "hidden",
        footer = "Get this info: https://api.stats.govt.nz/opendata/v1/data.json"
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {

  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Stats NZ OData API Client"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
