mid_tmpl_register <- \(con) {
  \(req, res) {
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
      error = ""
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
          error = error
        )
      )
    }

    res$template_profile <- \(
      email = "",
      urls = NULL
    ) {
      res$render(
        template_path(
          "profile.html"
        ),
        template_data(,
          con,
          req,
          email = user$email,
          urls = user$urls
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
