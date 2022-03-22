#' POST Delete URL
#' 
#' Delete a URL from the database
#' 
#' @inheritParams connection
#' 
#' @keywords internal
delete_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()
    url <- get_path(con, body$delete)

    # we eventually redirect regardless
    res$status <- 301L

    # could not find URL in database
    # for whatever reason, exit early
    if(nrow(url) == 0L)
      return(res$redirect("/profile"))

    # 
    if(req$cookie$rrr != as.character(url$user_id))
      return(res$redirect("/profile"))

    delete_url(con, body$delete)

    res$redirect("/profile")
  }
}