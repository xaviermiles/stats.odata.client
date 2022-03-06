# TODO: allow querying UAT API - argument in get functions?
#       This would need to switch between get_golem_config & get_golem_secret.
# TODO: how to effectively inheritParam with unexported functions?


#' Basic GET request to Stats NZ OData API, with paging when required.
#'
#' @description Derived from https://github.com/StatisticsNZ/open-data-api/
#'
#' @param endpoint API endpoint. Required.
#' @param entity Data entity.
#' @param query Query URL character (not URL-encoded).
#' @param timeout Timeout for the GET request(s), in seconds.
#'
#' @return A data frame containing the requested data.
#'
#' @export
basic_get <- function(endpoint, entity = "", query = "", timeout = 60) {
  # TODO: could query be more R style? list of query types rather than just string?
  detailed_get(endpoint, entity, query, timeout)$value
}


#' @name detailed_get
#'
#' @param endpoint API endpoint. Required.
#' @param entity Data entity.
#' @param query Query URL character (not URL-encoded).
#' @param timeout Timeout for the GET request(s), in seconds.
#'
#' @return A list of the response's contents.
#'
#' @include utils_odata_get.R
#' @noRd
detailed_get <- function(endpoint, entity = "", query = "", timeout = 60) {
  initial_url <- build_basic_url(endpoint, entity, query)
  top_query <- grepl("$top", query, fixed = TRUE)

  result <- data.frame()
  url <- initial_url
  while (!is.null(url)) {
    content <- send_get(url, timeout)
    result <- rbind(result, content$value)
    if (top_query)
      break
    url <- content$"@odata.nextLink"
  }

  return(list(value = result, initial_url = initial_url))
}


#' Constructs request URLs.
#'
#' @param endpoint API endpoint. Required.
#' @param entity Data entity.
#' @param query Query URL character (not URL-encoded).
#'
#' @noRd
build_basic_url <- function(endpoint, entity = "", query = "") {
  # TODO: check for NULL service. Here or somewhere else?
  service <- get_golem_config("service_prd")
  url <- glue::glue("{service}/{endpoint}")
  if (entity != "")
    url <- glue::glue("{url}/{entity}")
  if (query != "")
    url <- glue::glue("{url}?{query}")

  return(utils::URLencode(url))
}


#' GET the catalogue of Stats NZ OData API.
#'
#' @description Derived from https://github.com/StatisticsNZ/open-data-api/
#'
#' @param endpoint API endpoint.
#' @param timeout Timeout for the GET request, in seconds.
#'
#' @return A data frame containing the requested catalogue data. This is
#' generally not a "tidy dataset" since it uses prefixes to represent some of
#' the more nested content.
#'
#' @export
get_catalogue <- function(endpoint = "data.json", timeout = 60) {
  # TODO: would this ever need to page??
  service <- get_golem_config("service_prd")
  # TODO: as above re NULL service.
  url <- utils::URLencode(glue::glue("{service}/{endpoint}"))
  content <- send_get(url, timeout)

  if (!"dataset" %in% names(content))
    stop("Response doesn't contain 'dataset'")

  catalogue <- tidyr::unnest_longer(content$dataset, distribution)
  return(catalogue)
}
