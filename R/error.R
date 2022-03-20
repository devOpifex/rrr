
#' Error
#' 
#' Rendering errors (!= 200).
#' 
#' @name errors
#' 
#' @keywords internal
render_404 <- \(req, res){
  res$status <- 404L
  res$send_file(
    template_path("404.html")
  )
}

#' @rdname errors
#' @keywords internal
render_500 <- \(req, res){
  res$status <- 500L
  res$send(
    "Internal server error"
  )
}
