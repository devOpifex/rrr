MIN_PASSWORD_LENGTH <- 6L

register_get <- \(con) {
  \(req, res) {
    if(is_authenticated(con, req$cookie$rrr)){
      res$status <- 301L
      return(res$redirect("/login"))
    }

    res$template_register()
  }
}

register_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    # missing inputs
    if(is.null(body$email))
      return(
        res$template_register(
          "Missing email"
        )
      )

    if(is.null(body$password) || is.null(body$password2))
      return(
        res$template_register(
          "Missing password"
        )
      )

    # passwords do not match
    if(body$password != body$password2)
      return(
        res$template_register(
          password = "Passwords do not match"
        )
      )

    # password too short
    if(nchar(body$password) < MIN_PASSWORD_LENGTH)
      return(
        res$template_register(
          password = "Password must be at least 5 characters long"
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
    res$cookie(
      "rrr",
      user$id
    )

    res$template_register(
      success = "Account created"
    )
  }
}
