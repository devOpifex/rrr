mid_tmpl_register <- \(con) {
  \(req, res) {
    req$authenticated <- is_authenticated(con, req$cookie$rrr)

    res$template_register <- \(
      username = "",
      password = "",
      existing_email = ""
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
          existing_email = existing_email
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
      urls = list(),
      url = "",
      shortened = "",
      path_error = "",
      error = ""
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
          url = url,
          shortened = shortened,
          path_error = path_error,
          error = error
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
