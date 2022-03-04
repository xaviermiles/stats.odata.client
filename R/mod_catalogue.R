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

  tagList(
    mainPanel(
      width = 12,
      uiOutput(ns("landing_page_boxes"))
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
    selected_endpoint <- reactiveVal()

    get_landing_page_box <- function(title, button_name, description) {
      div(
        class="landing-page-box",
        div(title, class = "landing-page-box-title"),
        div(description, class = "landing-page-box-description"),
        # div(class = "landing-page-icon"),
        actionButton(NS(id, button_name), NULL, class="landing-page-button")
      )
    }

    get_row_of_boxes <- function(catalogue_row_nums) {
      # TODO: parameterise number of boxes per row? Currently hard-coded via
      #       width of column elements.
      purrr::map(
        catalogue_row_nums,
        function(i) {
          column(
            4,
            get_landing_page_box(catalogue[i, "title"],
                                 paste0("catalogue_row_num_", i),
                                 catalogue[i, "description"])
          )
        }
      ) %>%
        purrr::lift(fluidRow)(.)
    }

    output$landing_page_boxes <- renderUI({
      purrr::map(
        1:NUM_FLUID_ROWS,
        function(i) {
          catalogue_row_nums <- (3*i - 2):(3*i)
          row_of_boxes <- get_row_of_boxes(catalogue_row_nums)
          return(row_of_boxes)
        }
      )
    })

    purrr::map(
      1:(3 * NUM_FLUID_ROWS),
      function(box) {
        observeEvent(input[[paste0("catalogue_row_num_", box)]], {
          # Seems weird that the catalogue doesn't provide endpoint as column,
          # it only provides the whole service+endpoint URL.
          # -> Takes everything past last forward-slash:
          url <- catalogue$identifier[box]
          endpoint <- sub(".+/(.+)$", "\\1", url)
          selected_endpoint(endpoint)
        })
      }
    )

    # selected_endpoint <- "Covid-19Indicators"
    return(selected_endpoint)
  })
}
