#' GET Profile
#' 
#' Returns the profile page, unless the user is not
#' authenticated in which case it redirects to the login
#' page.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
profile_get <- \(con) {
  \(req, res) {
    # user is not authenticated
    # we redirect
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

#' POST Profile
#' 
#' Handle form POSTed from /profile, namely the
#' URL shortening.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
profile_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()
    user <- get_user_by_id(con, req$cookie$rrr)

    # user is not authenticated: we redirect
    if(!req$authenticated) {
      res$status <- 301L
      return(
        res$redirect("/profile/login")
      )
    }

    urls <- get_urls(con, req$cookie$rrr)

    # missing URL we return error message
    if(is.null(body$url))
      return(
        res$template_profile(
          email = user$email,
          error = "Missing URL",
          urls = urls
        )
      )

    # missing path, we return error
    if(is.null(body$path))
      return(
        res$template_profile(
          email = user$email,
          path_error = "Missing path",
          url = body$url,
          urls = urls
        )
      )

    # in the event the above checks failed
    # we return an error
    if(length(body) < 2)
      return(
        res$template_profile(
          email = user$email,
          error = "Missing inputs",
          urls = urls
        )
      )

    if(!is_valid_path(body$path))
      return(
        res$template_profile(
          email = user$email,
          path_error = "Invalid path, only accepts alphanumeric",
          urls = urls
        )
      )

    # path already exists
    # (could be any other users)
    # we return an error
    if(path_exists(con, body$path)) {
      return(
        res$template_profile(
          email = user$email,
          path_error = "Already exists",
          url = body$url,
          urls = urls
        )
      )
    }
    
    # add path to the database
    add_path(
      con,
      req$cookie$rrr,
      body$url,
      body$path
    )

    # we rerun this to to obtain updated
    # data (after `add_path` operation)
    urls <- get_urls(con, req$cookie$rrr)
    
    res$template_profile(
      email = user$email,
      urls = urls,
      shortened = shortened_path(body$path)
    )
  }
}

#' Create Shortened URL
#' 
#' Create shortened URL from path.
#' 
#' @param path Path to create URL with.
#' 
#' @keywords internal
shortened_path <- \(path) {
  sprintf(
    "%s%s",
    BASE_URL,
    path
  )
}

#' Profile Router
#' 
#' Router for convenience and easier organisation
#' on the profile.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
profile <- \(con) {
  # all routes (get, post, ...)
  # will be preprended by /profile
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

#' Valid Path
#' 
#' Ensures we have a valid path.
#' We only accept alphanumeric.
#' 
#' @param path Path to check
#' 
#' @return bool/logical.
#' 
#' @keywords internal
is_valid_path <- \(path) {
  grepl("^[[:alnum:]]+$", "hello")
}