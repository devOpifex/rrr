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
