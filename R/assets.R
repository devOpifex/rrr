#' Path to Package File
#' 
#' Path to `inst`.
#' 
#' @param path Path, character.
#' 
#' @keywords internal
pkg_file <- \(path) {
  system.file(path, package = "rrr")
}

#' Path to Assets
#' 
#' Path to static files.
#' 
#' @return Path to `inst/assets`.
#' 
#' @keywords internal
assets_path <- \() {
  pkg_file("assets")
}

#' Template Path
#' 
#' Create a path to the `templates` in `inst/templates`.
#' 
#' @param ... Path, character.
#' 
#' @keywords internal
template_path <- \(...) {
  tmpls <- pkg_file("templates")
  file.path(tmpls, ...)
}
