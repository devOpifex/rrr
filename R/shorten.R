#' Redirect shroten
#' 
#' Redirects shortened links if found.
#' Otherwise we return 404.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
shorten_redirect <- \(con) {
  \(req, res) {
    path <- get_path(con, req$params$path)

    if(nrow(path) == 0L) {
      return(
        render_404(req, res)
      )
    }

    # increment data
    increment_data(con, req$params$path)

    res$status <- 302L
    res$redirect(path$original)
  }
}