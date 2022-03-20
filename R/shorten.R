shorten_redirect <- \(con) {
  \(req, res) {
    path <- get_path(con, req$params$path)

    if(nrow(path) == 0L) {
      return(
        render_404(req, res)
      )
    }

    res$status <- 302L
    res$redirect(path$original)
  }
}