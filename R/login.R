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

login_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    if(is.null(body$email))
      return(
        res$template_login(
          "Missing email"
        )
      )
    
    if(is.null(body$password))
      return(
        res$template_login(
          password = "Missing password",
          existing_email = body$email
        )
      )

    if(nchar(body$password) < MIN_PASSWORD_LENGTH)
      return(
        res$template_login(
          password = "Invalid password",
          existing_email = body$email
        )
      )

    user <- authenticate_user(con, body$email, body$password)

    if(nrow(user) == 0L)
      return(
        res$template_login(
          error = "Invalid credentials",
          existing_email = body$email
        )
      )

    res$cookie(
      "rrr",
      user$id
    )

    res$status <- 302L
    res$redirect("/profile")
  }
}
