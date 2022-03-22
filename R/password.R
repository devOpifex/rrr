#' Encrypt password
#' 
#' Encrypts the password using SHA256 then
#' base64 encode.
#' 
#' @importFrom digest hmac
#' @importFrom base64enc base64encode
#' 
#' @keywords internal
password_encrypt <- \(password) {
  hmac(
    get_key(),
    password,
    algo = "sha256"
  ) |> 
    charToRaw() |> 
    base64encode()
}

#' Retrieve Secret
#' 
#' Retrieve secret key (environment variable).
#' 
#' @keywords internal
get_key <- \(){
  key <- Sys.getenv("RRR_KEY", "")

  if(key == "")
    stop("Missing `RRR_KEY`", call. = FALSE)

  return(key)
}
