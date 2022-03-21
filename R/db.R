#' Setup Database
#' 
#' @inheritParams build
#' 
#' @importFrom DBI dbExecute
#' 
#' @export
setup_database <- \(con) {
  dbExecute(
    con,
    "CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT,
      password_hash TEXT NOT NULL,
      verified INTEGER DEFAULT 0
    )"
  )

  dbExecute(
    con,
    "CREATE TABLE IF NOT EXISTS urls (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      original TEXT NOT NULL,
      hash TEXT NOT NULL
    )"
  )

  invisible()
}

#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
get_user_by_id <-\(con, id) {
  query <- sprintf(
    "SELECT * FROM users WHERE id = ?"
  )
  user <- dbSendQuery(con, query)
  dbBind(user, list(id))
  on.exit({
    dbClearResult(user)
  })
  dbFetch(user)
}

#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
get_user <-\(con, email) {
  query <- sprintf(
    "SELECT * FROM users WHERE email = ?"
  )
  user <- dbSendQuery(con, query)
  dbBind(user, list(email))
  on.exit({
    dbClearResult(user)
  })
  dbFetch(user)
}

#' @importFrom DBI dbSendQuery dbBind dbClearResult
user_update_password <- \(con, id, password_hash) {
  query <- sprintf(
    "UPDATE users SET password_hash = ? WHERE id = ?"
  )
  user <- dbSendStatement(con, query)
  dbBind(user, list(password_hash, id))
  on.exit({
    dbClearResult(user)
  })
}

#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
user_exists <-\(con, email) {
  user <- get_user(con, email)
  as.logical(nrow(user))
}

#' @importFrom DBI dbAppendTable
create_user <-\(con, email, password) {
  password <- password_encrypt(password) 

  new_user <- data.frame(
    email = email,
    password_hash = password,
    verified = 0L
  )

  dbAppendTable(
    con,
    "users",
    new_user
  )

  get_user(con, email)
}

authenticate_user <- \(con, email, password) {
  hashed <- password_encrypt(password)
  query <- sprintf(
    "SELECT * FROM users WHERE email = ? AND password_hash = ?"
  )
  user <- dbSendQuery(con, query)
  dbBind(user, list(email, hashed))
  on.exit({
    dbClearResult(user)
  })
  dbFetch(user)
}

get_path <- \(con, path) {
  query <- sprintf(
    "SELECT * FROM urls WHERE hash = ?"
  )
  obj <- dbSendQuery(con, query)
  dbBind(obj, list(path))
  on.exit({
    dbClearResult(obj)
  })
  dbFetch(obj)
}

path_exists <- \(con, path) {
  if(path %in% FORBIDDEN_PATHS)
    return(TRUE)

  p <- get_path(con, path)

  if(nrow(p) == 0L)
    return(FALSE)

  return(TRUE)
}

add_path <- \(con, user_id, original, hash) {
  row <- data.frame(
    user_id = user_id,
    original = original,
    hash = hash
  )
  dbAppendTable(con, "urls", row)
}

get_urls <- \(con, user_id) {
  query <- sprintf(
    "SELECT * FROM urls WHERE user_id = ?"
  )
  obj <- dbSendQuery(con, query)
  dbBind(obj, list(user_id))
  on.exit({
    dbClearResult(obj)
  })
  dbFetch(obj)
}

#' @importFrom DBI dbSendStatement
delete_url <- \(con, path) {
  query <- sprintf(
    "DELETE FROM urls WHERE hash = ?"
  )
  obj <- dbSendStatement(con, query)
  dbBind(obj, list(path))
  on.exit({
    dbClearResult(obj)
  })
}
