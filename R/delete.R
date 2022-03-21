delete_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()
    url <- get_path(con, body$delete)
    res$status <- 301L

    if(nrow(url) == 0L)
      return(res$redirect("/profile"))

    if(req$cookie$rrr != as.character(url$user_id))
      return(res$redirect("/profile"))

    delete_url(con, body$delete)

    res$redirect("/profile")
  }
}