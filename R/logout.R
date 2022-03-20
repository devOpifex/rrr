logout_get <- \(req, res) {
  res$clear_cookie("rrr")
  res$status <- 301L
  res$redirect("/")
}