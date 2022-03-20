is_authenticated <- \(con, cookie) {
  if(length(cookie) == 0L)
    return(FALSE)

  user <- get_user_by_id(con, cookie)

  if(nrow(user) > 0)
    return(TRUE)

  return(FALSE)
}