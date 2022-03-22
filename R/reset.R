reset_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    res$status <- 301L

    if(is.null(body$passwordOld) || is.null(body$passwordNew) || is.null(body$passwordNew2))
      return(res$redirect("/profile"))

    # passwords do not match
    if(body$passwordNew != body$passwordNew2)
      return(res$redirect("/profile"))

    user <- get_user_by_id(con, req$cookie$rrr)

    old_password <- password_encrypt(body$passwordOld)

    if(old_password != user$password_hash)
      return(res$redirect("/profile"))

    new_password <- password_encrypt(body$passwordNew)
    user_update_password(con, req$cookie$rrr, new_password)

    res$clear_cookie("rrr")
    res$redirect("/profile/login")
  }
}