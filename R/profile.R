profile_get <- \(con) {
  \(req, res) {
    if(!is_authenticated(con, req$cookie$rrr)){
      res$status <- 301L
      return(
        res$redirect("/login")
      )
    }

    user <- get_user_by_id(con, req$cookie$rrr)

    res$template_profile(
      email = user$email,
      urls = user$urls
    )
  }
}