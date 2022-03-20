mid_tmpl_register <- \(req, res) {
  res$template_register <- \(
    username = "",
    password = "",
    success = ""
  ) {
    res$render(
      template_path(
        "register.html"
      ),
      list(
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
      list(
        username = username,
        password = password,
        error = error
      )
    )
  }
}
