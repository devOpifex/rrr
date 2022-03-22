#' GET Login
#' 
#' Returns login page response, unless the user
#' is already authenticated in which case we redirect
#' to profile.
#' 
#' @inheritParams res
#' @inheritParams req
#' 
#' @keywords internal
login_get <- \(req, res) { 
  # user is already signed in
  if(req$authenticated){
    res$status <- 302L
    return(
      res$redirect("/profile")
    )
  }

  res$template_login()
}

#' POST Login
#' 
#' Handles `POST` request to `/login`.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
login_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    # Missing email
    # return with error message
    if(is.null(body$email))
      return(
        res$template_login(
          "Missing email"
        )
      )
    
    # Missing password
    # return with error message
    if(is.null(body$password))
      return(
        res$template_login(
          password = "Missing password",
          existing_email = body$email
        )
      )

    # ensure a minimum length for passwords (reasonable)
    if(nchar(body$password) < MIN_PASSWORD_LENGTH)
      return(
        res$template_login(
          password = "Invalid password",
          existing_email = body$email
        )
      )

    user <- authenticate_user(con, body$email, body$password)

    # we could not find the user in the database
    # likely cause: invalid credentials (bad password)
    # we intenionally do not tell the user it's an
    # issue with the password.
    if(nrow(user) == 0L)
      return(
        res$template_login(
          error = "Invalid credentials",
          existing_email = body$email
        )
      )

    set_cookie(res, user$id)

    res$status <- 302L
    res$redirect("/profile")
  }
}
