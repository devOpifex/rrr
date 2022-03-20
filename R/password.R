password_encrypt <- \(password) {
  digest::hmac(
    get_key(),
    password,
    algo = "sha256"
  ) |> 
    charToRaw() |> 
    base64enc::base64encode()
}

get_key <- \(){
  key <- Sys.getenv("RRR_KEY", "")

  if(key == "")
    stop("Missing `RRR_KEY`", call. = FALSE)

  return(key)
}
