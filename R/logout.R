#' GET Logout
#' 
#' Logout, clears cookie and redirects to homepage.
#' 
#' @inheritParams res
#' @inheritParams req
#' 
#' @keywords internal
logout_get <- \(req, res) {
  res$clear_cookie("rrr")
  res$status <- 301L
  res$redirect("/")
}