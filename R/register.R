# Minimum password length
MIN_PASSWORD_LENGTH <- 6L

#' GET Register
#' 
#' Returns register page, unless the user is 
#' authenticated in which case we redirect to
#' the profile.
#' 
#' @inheritParams req
#' @inheritParams res
#' 
#' @keywords internal
register_get <- \(req, res) {
  if(req$authenticated){
    res$status <- 301L
    return(res$redirect("/profile"))
  }

  res$template_register()
}

#' Post Register
#' 
#' Handles registration.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
register_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    # missing email, send error
    if(is.null(body$email))
      return(
        res$template_register(
          "Missing email"
        )
      )
    
    # ensure the email is valid
    # (that it is an acutal email address)
    # front-end does some of that too
    if(!is_email(body$email)) 
      return(
        res$template_register(
          "Invalid email"
        )
      )

    # missing either password
    if(is.null(body$password) || is.null(body$password2))
      return(
        res$template_register(
          password = "Missing password",
          existing_email = body$email
        )
      )

    # passwords do not match, we send an error
    if(body$password != body$password2)
      return(
        res$template_register(
          password = "Passwords do not match",
          existing_email = body$email
        )
      )

    # password too short
    if(nchar(body$password) < MIN_PASSWORD_LENGTH)
      return(
        res$template_register(
          password = "Password must be at least 5 characters long",
          existing_email = body$email
        )
      )

    # user already exists
    if(user_exists(con, body$email))
      return(
        res$template_register(
          username = "User already exists"
        )
      )

    # create user
    user <- create_user(con, body$email, body$password)
    set_cookie(res, user$id)

    res$status <- 301L
    res$redirect("/profile")
  }
}

#' Is Email
#' 
#' Basic regex check to ensure the email address is valid.
#' 
#' @param email Email address to check.
#' 
#' @return boolean/logical.
#' 
#' @keywords internal
is_email <- \(email) {
  if(!grepl("^[^@\\s]+@[^@\\s]+$", email, perl = TRUE))
    return(FALSE)

  if(!grepl("\\.", email))
    return(FALSE)

  return(TRUE)
}
