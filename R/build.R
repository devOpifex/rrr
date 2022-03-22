#' Build
#' 
#' Build the application
#' 
#' @param con Database connection.
#' 
#' @import ambiorix
#' @importFrom alesia alesia
#' @importFrom scilis scilis
#' @importFrom signaculum signaculum
#' 
#' @return An object of class `Ambiorix`.
#' 
#' @export 
build <- \(con) {
  if(missing(con))
    stop("Missing con")

  app <- Ambiorix$new()

  app$use(alesia())
  app$use(scilis(get_key()))
  app$use(mid_tmpl_register(con))
  app$use(
    signaculum(
      system.file("assets/img/favicon.ico", package = "rrr")
    )
  )

  # profile router
  app$use(profile(con))

  # 404 page
  app$not_found <- render_404

  # 500 server errors
  app$error <- render_500

  # serve static files
  app$static(assets_path(), "static")

  # homepage
  app$get("/", home_get(con))

  # redirect
  app$get("/:path", shorten_redirect(con))

  return(app)
}
