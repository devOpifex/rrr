profile_get <- \(con) {
  \(req, res) {
    if(!req$authenticated){
      res$status <- 301L
      return(
        res$redirect("/login")
      )
    }

    user <- get_user_by_id(con, req$cookie$rrr)
    urls <- get_urls(con, user$id)

    res$template_profile(
      email = user$email,
      urls = urls
    )
  }
}

profile_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()
    user <- get_user_by_id(con, req$cookie$rrr)

    if(is.null(body$url))
      return(
        res$template_profile(
          email = user$email,
          error = "Missing URL"
        )
      )

    if(is.null(body$path))
      return(
        res$template_profile(
          email = user$email,
          path_error = "Missing path",
          url = body$url
        )
      )

    if(length(body) < 2)
      return(
        res$template_profile(
          email = user$email,
          error = "Missing inputs"
        )
      )

    # path exists
    if(path_exists(con, body$path))
      return(
        res$template_profile(
          email = user$email,
          path_error = "Already exists",
          url = body$url
        )
      )

    add_path(
      con,
      req$cookie$rrr,
      body$url,
      body$path
    )
    
    urls <- get_urls(con, req$cookie$rrr)

    res$template_profile(
      email = user$email,
      urls = urls,
      shortened = shortened_path(body$path)
    )
  }
}

shortened_path <- \(path) {
  sprintf(
    "%s%s",
    BASE_URL,
    path
  )
}

ws_delete_url <- \(con) {
  \(msg, ws) {
    delete_url(con, msg)
  }
}
