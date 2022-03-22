#' Auth Check
#' 
#' Checks whether a user is actually authenticated.
#' 
#' @keywords con Database connection.
#' @param cookie Cookie as returned by `req$cookie$rrr`.
#' 
#' @keywords internal
is_authenticated <- \(con, cookie) {
  # we are using scilis
  # github.con/devOpifex/scilis
  # if the cookie has been tempered with
  # it returns `character(0)`
  # if it has we return FALSE
  if(length(cookie) == 0L)
    return(FALSE)

  # cookie is valie but we nonetheless
  # check the database to make sure
  # we can find said user
  user <- get_user_by_id(con, cookie)

  if(nrow(user) > 0)
    return(TRUE)

  return(FALSE)
}

set_cookie <- \(res, id) {
  # set auth cookie
  # expires in 3 months
  res$cookie(
    "rrr",
    id,
    path = "/",
    expires = Sys.Date() + 90L
  )
}