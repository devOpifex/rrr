profile_get <- \(con) {
  \(req, res) {
    if(!cookie_valid(con, req$cookie$rrr)){
      res$status <- 301L
      return(
        res$redirect("/login")
      )
    }

    user <- get_user_by_id(con, req$cookie$rrr)

    res$render(
      template_path(
        "profile.html"
      ),
      list(
        email = user$email,
        urls = user$urls
      )
    )
  }
}