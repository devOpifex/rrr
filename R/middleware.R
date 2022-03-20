mid_tmpl_register <- \(con) {
  \(req, res) {
    req$authenticated <- is_authenticated(con, req$cookie$rrr)

    res$template_register <- \(
      username = "",
      password = "",
      success = ""
    ) {
      res$render(
        template_path(
          "register.html"
        ),
        template_data(
          con,
          req,
          username = username,
          password = password,
          success = success
        )
      )
    }

    res$template_login <- \(
      username = "",
      password = "",
      error = "",
      existing_email = ""
    ) {
      res$render(
        template_path(
          "login.html"
        ),
        template_data(
          con,
          req,
          username = username,
          password = password,
          error = error,
          existing_email = existing_email
        )
      )
    }

    res$template_profile <- \(
      email = "",
      urls = NULL,
      url = ""
    ) {
      res$render(
        template_path(
          "profile.html"
        ),
        template_data(
          con,
          req,
          email = email,
          urls = urls,
          url = url
        )
      )
    }
  }
}

template_data <- \(con, req, ...) {
  data <- list(
    ...
  )

  data$authenticated <- is_authenticated(
    con, 
    req$cookie$rrr
  )

  return(data)
}
