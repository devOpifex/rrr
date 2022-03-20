#' Home
#' 
#' Render the homepage.
#' 
#' @inheritParams handler
#' 
#' @name views
#' 
#' @keywords internal
home_get <- \(con){
  \(req, res) {
    res$render(
      template_path("home.html"),
      template_data(con, req)
    )
  }
}
