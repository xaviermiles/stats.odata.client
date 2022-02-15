# TODO: allow querying UAT API - argument in get functions?
#       This would need to switch between get_golem_config & get_golem_secret.


#' basic_get
#'
#' @description Basic GET request to Stats NZ OData API.
#'
#' Derived from https://github.com/StatisticsNZ/open-data-api/
#'
#' @param endpoint API endpoint. Required.
#' @param entity Data entity. Required.
#' @param query Query URL character (not URL-encoded).
#' @param timeout Timeout for the GET request(s), in seconds.
#'
#' @return A data frame containing the requested data.
#'
#' @include utils_odata_get.R
#' @export
basic_get <- function(endpoint, entity, query = "", timeout = 60) {
  service <- get_golem_config("service_prd")
  # TODO: check for NULL service. Here or somewhere else?
  url <- glue::glue("{service}/{endpoint}/{entity}",
                    if (query != "") "?{query}" else "") %>%
    utils::URLencode()
  top_query <- grepl("$top", query, fixed = TRUE)

  result <- data.frame()
  while (!is.null(url)) {
    content <- send_get(url, timeout)
    result <- rbind(result, content$value)
    if (top_query)
      break
    url <- content$"@odata.nextLink"
  }

  return(result)
}


#' get_catalogue
#'
#' @description Send GET request to catalogue of Stats NZ OData API.
#'
#' Derived from https://github.com/StatisticsNZ/open-data-api/
#'
#' @param endpoint API endpoint.
#' @param timeout Timeout for the GET request, in seconds.
#'
#' @return A data frame containing the requested catalogue data. This is
#' generally not a tidy dataset since it uses prefixes to represent some of
#' the more nested content.
#'
#' @export
get_catalogue <- function(endpoint = "data.json", timeout = 60) {
  service <- get_golem_config("service_prd")
  # TODO: as above re NULL service.
  url <- utils::URLencode(glue::glue("{service}/{endpoint}"))
  content <- send_get(url, timeout)

  if (!"dataset" %in% names(content))
    stop("Response doesn't contain 'dataset'")

  catalogue <- content$dataset %>% tidyr::unnest_longer(distribution)
  return(catalogue)
}
