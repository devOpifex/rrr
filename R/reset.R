#' POST Reset
#' 
#' Handles password reset.
#' 
#' @inheritParams connection
#' 
#' @keywords internal
reset_post <- \(con) {
  \(req, res) {
    body <- req$parse_multipart()

    # user is actually already
    # autheticated, we redirect
    if(!req$authenticated){
      res$status <- 301L
      return(res$redirect("/profile"))
    }

    res$status <- 301L

    # any input missing, we redicrect
    if(is.null(body$passwordOld) || is.null(body$passwordNew) || is.null(body$passwordNew2))
      return(res$redirect("/profile"))

    # passwords do not match
    if(body$passwordNew != body$passwordNew2)
      return(res$redirect("/profile"))

    # get the user record trying to reset password
    user <- get_user_by_id(con, req$cookie$rrr)

    # hash the "old password" entered
    old_password <- password_encrypt(body$passwordOld)

    # "old" hash does not match database
    # we redirect
    if(old_password != user$password_hash)
      return(res$redirect("/profile"))

    # create new password
    new_password <- password_encrypt(body$passwordNew)
    user_update_password(con, req$cookie$rrr, new_password)

    # we clear the cookie and force the user
    # to login again
    res$clear_cookie("rrr")
    res$redirect("/profile/login")
  }
}