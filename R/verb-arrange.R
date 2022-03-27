#' Arrange rows by column values
#'
#' @description
#' This is a method for the dplyr [arrange()] generic. It contributes towards
#' the `$orderby` query of the API request.
#' TODO: What is window_order() ?
#'
#' @param .data A lazy odata frame backed by an API query.
#' @inheritParams dplyr::arrange
#' @return Another `otbl_lazy`. Use [show_query()] to see the generated query,
#'   and use [`collect()`][collect.tbl_oquery] to executre the query and return
#'   data to R.
