#' Get app secret
#'
#' @description A utils function to read secrets from either a
#' session memory or config file (in that order).
#'
#' @param value Secret value to retrieve from memory/disk.
#' @param config GOLEM_CONFIG_ACTIVE value. If unset, R_CONFIG_ACTIVE.
#' If unset, "default".
#' @param file File to read secret from.
#' @param use_parent Logical, scan the parent directory for secrets file.
#'
#' @return The secret character, if it exists. Otherwise, NULL.
#'
#' @include app_config.R
#' @noRd
get_secret <- function(
  value,
  config = "default",
  file = NULL,
  use_parent = TRUE
) {
  option_value <- getOption(glue::glue("golem.secrets.{value}"))
  if (!is.null(option_value))
    return(option_value)

  if (is.null(file))
    file <- app_sys("golem-secrets.yml")
  if (file == "" || !file.exists(file))
    stop("No golem-secrets.yml file.")
  file_value <- config::get(
    value = value,
    config = config,
    file = file,
    use_parent = use_parent
  )
  if (!is.null(file_value))
    return(file_value)
}

#' Set app secrets
#'
#' @description Sets secret for app, to be accessed by app during run-time or
#' by other exported functions. Saves it to global options, so this is stored
#' in memory for the lifetime of the current R session.
#'
#' P.S. don't have secrets hard-coded in your own code, read them in from
#' somewhere secretive
#'
#' @param ... Key-value pairs to be saved as "secrets" (all arguments should
#' be named).
#'
#' @export
set_secrets <- function(...) {
  args <- list(...)
  for (name in names(args)) {
    if (name == "")
      next
    setOption(glue::glue("golem.secrets.{name}"), args[[name]])
  }
}


#' Clear app secrets saved in memory.
#'
#' @noRd
clear_secrets <- function() {
  active_secrets <- names(options()) %>%
    .[stringr::str_detect(., "^golem\\.secrets\\.")]
  for (s in active_secrets) {
    setOption(s, NULL)
  }
}

#' Helper to set global option (corresponds to base::getOption)
#'
#' @noRd
setOption <- function(key, val) rlang::exec("options", !!key := val)  # nolint
