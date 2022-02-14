#' send_get
#'
#' @description A utils function to send GET request and unpack response, with
#' basic error catching.
#'
#' @param url URL-encoded character to dispatch.
#'
#' @return A list containing to the response content.
#'
#' @include utils_secrets.R
#' @noRd
send_get <- function(url, timeout) {
  key <- get_secret("subscription_key")
  if (is.null(key))
    stop("Please add your subscription key.")
  response <- httr::GET(
    url = url,
    httr::add_headers("Cache-Control" = "no-cache",
                      "Ocp-Apim-Subscription-Key" = key),
    httr::timeout(timeout)
  )

  if (httr::http_error(response)) {
    stop(glue::glue(
      "Sending GET request failed; \"{httr::http_status(response)$message}\""
    ))
  }

  content <- httr::content(response, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  return(content)
}
