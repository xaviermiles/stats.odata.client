#' Create an odata tbl
#'
#' @export
#' @param subclass Name of subclass.
#' @param vars Column names as a character vector
tbl.src_odata <- function(subclass, endpoint, entity, ..., vars = NULL) {
  from <- build_url(endpoint, entity)

  vars <- vars %||% get_odata_fields(from)

  dplyr::make_tbl(
    c(subclass, "odata", "lazy"),
    lazy_query = olazy_base(from)
  )
}
