#' catalogue UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_catalogue_ui <- function(id) {
  ns <- NS(id)

  get_lp_box <- function(title, button_name, description) {
    div(
      class="landing-page-box",
      div(title, class = "landing-page-box-title"),
      div(description, class = "landing-page-box-description"),
      # div(class = "landing-page-icon"),
      actionButton(button_name, NULL, class="landing-page-button")
    )
  }

  tagList(
    mainPanel(
      width = 12,
      fluidRow(
        column(4, class = "landing-page-column", get_lp_box("OTM", "OTM1", "Hello there friends!")),
        column(4, class = "landing-page-column", get_lp_box("Cough", "hh2", "That's not friendly..."))
      ),
      uiOutput(ns("fluid_row_boxes"))
    )
  )
}

#' catalogue Server Functions
#'
#' @noRd
mod_catalogue_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    # TODO: if is.null(subscription_key) -> prompt for key?

    catalogue <- get_catalogue()
    NUM_FLUID_ROWS <- 3 # global.R ?

    get_landing_page_box <- function(title, button_name, description) {
      div(
        class="landing-page-box",
        div(title, class = "landing-page-box-title"),
        div(description, class = "landing-page-box-description"),
        # div(class = "landing-page-icon"),
        actionButton(button_name, NULL, class="landing-page-button")
      )
    }

    get_fluid_row_box <- function(catalogue_row_nums) {
      # TODO: parameterise number of boxes per row? Currently hard-coded via
      #       width of column elements.
      purrr::map(
        catalogue_row_nums,
        function(i) {
          get_landing_page_box(catalogue[i, "title"],
                               paste0("poop", i),
                               catalogue[i, "description"])
        }
      ) %>%
        purrr::lift(function(...) column(4, ...))(.)
    }

    # Construct fluid rows
    output$fluid_row_boxes <- renderUI({
      purrr::map(
        1:NUM_FLUID_ROWS,
        function(i) {
          catalogue_row_nums <- (3*i - 2):(3*i)
          fluid_row <- get_fluid_row_box(catalogue_row_nums)
          return(fluid_row)
        }
      )
    })
  })
}

## To be copied in the UI
# mod_catalogue_ui("catalogue_ui_1")

## To be copied in the server
# mod_catalogue_server("catalogue_ui_1")
