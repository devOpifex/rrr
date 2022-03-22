profile_get <- \(con) {
  \(req, res) {
    if(!req$authenticated){
      res$status <- 301L
      return(
        res$redirect("/profile/login")
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
    
    urls <- get_urls(con, req$cookie$rrr)

    # path exists
    if(path_exists(con, body$path))
      return(
        res$template_profile(
          email = user$email,
          path_error = "Already exists",
          url = body$url,
          urls = urls
        )
      )

    add_path(
      con,
      req$cookie$rrr,
      body$url,
      body$path
    )
    
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

profile <- \(con) {
  router <- Router$new("/profile")

  # profile
  router$get("/", profile_get(con))
  router$post("/", profile_post(con))

  # register
  router$get("/register", register_get)
  router$post("/register", register_post(con))

  # login
  router$get("/login", login_get)
  router$post("/login", login_post(con))

  # logout
  router$get("/logout", logout_get)
  
  # delete
  router$post("/delete", delete_post(con))

  # reset
  router$post("/reset", reset_post(con))

  # data
  router$get("/data", data_get(con))

  return(router)
}
