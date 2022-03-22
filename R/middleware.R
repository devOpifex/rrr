#' Middleware
#' 
#' We could use multiple middleware functions...
#' 
#' @inheritParams connection
#' 
#' @keywords internal
mid_tmpl_register <- \(con) {
  \(req, res) {

    # add to the request
    # whether the user is autheticated
    # this is useful in so many places.
    req$authenticated <- is_authenticated(con, req$cookie$rrr)

    # create a method to render template
    # for the register page
    # e.g.: res$remtplate_register()
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

    # create a method to render template
    # for the login page
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

    # create a method to render template
    # for the profile page
    res$template_profile <- \(
      email = "",
      urls = list(),
      url = "",
      shortened = "",
      path_error = "",
      error = "",
      password = ""
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
          error = error,
          password = password
        )
      )
    }
  }
}

#' Template Data
#' 
#' All `template_*` methods added in `middleware`
#' use this same function.
#' Useful to add data that is required in every 
#' (or most) templates, e.g.: whether
#' the user is authenticated.
#' 
#' @inheritParams connection
#' @inheritParams req
#' @param ... Additional data (key value pairs).
#' 
#' @keywords internal
template_data <- \(con, req, ...) {
  data <- list(...)
  data$authenticated <- req$authenticated
  return(data)
}
