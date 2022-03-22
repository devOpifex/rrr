#' Setup Database
#' 
#' Setup the database (creates tables),
#' if necessary.
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

  dbExecute(
    con,
    "CREATE TABLE IF NOT EXISTS data (
      url_id INTEGER,
      date TEXT,
      count INTEGER DEFAULT 0
    )"
  )

  invisible()
}

#' Retrieve a User
#' 
#' Retrieve a user record given it's unique id.
#' 
#' @inheritParams connection
#' @param id Id of user, an integer.
#' 
#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
#' 
#' @keywords internal
get_user_by_id <-\(con, id) {
  # we use parametrised queries because this 
  # data comes from the client
  # it should protect against injections
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

#' Get user by email
#' 
#' Retrieve a user record given its email address.
#' 
#' @inheritParams connection
#' @param email Email address.
#' 
#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
#' 
#' @keywords internal
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

#' Update a user password
#' 
#' Updates a user's password.
#' 
#' @inheritParams connection
#' @param id Id of the user.
#' @param password_hash Hashed password as returned by [password_encrypt()].
#' 
#' @importFrom DBI dbSendQuery dbBind dbClearResult
#' 
#' @keywords internal
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

#' User exists
#' 
#' Checks whether a user exists.
#' 
#' @inheritParams connection
#' @param email Email of the user.
#' 
#' @importFrom DBI dbSendQuery dbBind dbClearResult dbFetch
#' 
#' @keywords internal
user_exists <-\(con, email) {
  user <- get_user(con, email)
  as.logical(nrow(user))
}

#' Create a user
#' 
#' Creates a new user record.
#' 
#' @inheritParams connection
#' @param email User's email.
#' @param password Raw password (this function encrypts it).
#' 
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

#' Authenticate a user
#' 
#' Authenticates a user; compares password hashes.
#' 
#' @inheritParams connection
#' @param email,password User credentials.
#' 
#' @keywords internal
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

#' Retrieve a URL record
#' 
#' Retrieve a URL record given its path.
#' 
#' @inheritParams connection
#' @param path Path to retrieve record.
#' 
#' @keywords internal
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

#' Path exists
#' 
#' Checks whether a path exists.
#' 
#' @inheritParams connection
#' @param path Path to check.
#' 
#' @return boolean, logical.
#' 
#' @keywords internal
path_exists <- \(con, path) {
  # a list of forbidden paths
  # to avoid the user highjacking
  # our own website
  # ambiorix would not allow it to happend
  # but we're better on the safe side
  if(path %in% FORBIDDEN_PATHS)
    return(TRUE)

  p <- get_path(con, path)

  if(nrow(p) == 0L)
    return(FALSE)

  return(TRUE)
}

#' Add a path
#' 
#' Adds a record path to the database.
#' 
#' @inheritParams connection
#' @param user_id Id of the user adding the path.
#' @param original Original URL, URL being shortened.
#' @param hash Path of the shortened URL.
#' 
#' @keywords internal
add_path <- \(con, user_id, original, hash) {
  row <- data.frame(
    user_id = user_id,
    original = original,
    hash = hash
  )
  dbAppendTable(con, "urls", row)
}

#' Get URLs
#' 
#' Retrieve URLs of a given user.
#' 
#' @inheritParams connection
#' @param user_id Id of user.
#' 
#' @inheritParams connection
#' 
#' @keyword internal
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

#' Delete a URL
#' 
#' Delete a url from the database.
#' 
#' @inheritParams connection
#' @param path Path to delete.
#' 
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

#' Increment count
#' 
#' Increment the count for a given path.
#' 
#' This is used to increment the `data` table at
#' every redirect. 
#' We only store the `url_id`, the `date`, and the `count`.
#' 
#' @inheritParams connection
#' @param path Path to increment
#' 
#' @importFrom DBI dbGetQuery
#' 
#' @name increment
#' 
#' @keywords internal
increment_data <- \(con, path) {
  # get today's date
  date <- Sys.Date()

  # get path id
  path <- get_path(con, path)

  # check if row exists
  # there is no upsert
  # this'll determine whether we 
  # update or create a record
  existing <- dbGetQuery(
    con,
    sprintf(
      "SELECT count FROM data WHERE date = '%s' AND url_id = %s",
      date,
      path$id
    )
  )

  # as.logical(1) = TRUE
  # as.logical(0) = FALSE
  exists <- as.logical(nrow(existing))

  # it exists, we UPDATE
  if(exists) {
    update_data(con, date, path$id, existing$count)
    return()
  }

  # it does not exist we INSERT INTO
  create_data(con, date, path$id)
}

#' @rdname increment
#' @importFrom DBI dbExecute
update_data <- \(con, date, id, count) {
  count <- count + 1
  dbExecute(
    con,
    sprintf(
      "UPDATE data SET count = %s WHERE date = '%s' AND url_id = %s;",
      count,
      date,
      id
    )
  )
}

#' @rdname increment
#' @importFrom DBI dbExecute
create_data <- \(con, date, id) {
  dbExecute(
    con,
    sprintf(
      "INSERT INTO data (
        url_id,
        date,
        count
      )
      VALUES (
        %s,
        '%s',
        %s
      );",
      id,
      date,
      1L
    )
  )
}

#' Retrieve data
#' 
#' Retrieve the data of a given URL.
#' 
#' @inheritParams connection
#' @param hash Path to retrieve data for.
#' 
#' @keywords internal
get_hash_data <- \(con, hash) {
  # we tail() to ensure
  # we don't have to send too much data
  # 1) could easily handle more
  # 2) should paginate or do this smartly.
  query <- sprintf(
    "SELECT data.date, data.count FROM urls
    LEFT JOIN data ON urls.id = data.url_id
    WHERE hash = '%s';",
    hash
  )
  dbGetQuery(con, query) |> 
    utils::tail(90L)
}
