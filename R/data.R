data_get <- \(con) {
  \(req, res) {
    if(!req$authenticated) {
      return(
        res$json(
          list(
            error = "User not authenticated"
          )
        )
      )
    }

    if(length(req$query$hash) == 0L) {
      return(
        res$json(
          list(
            error = "Missing path"
          )
        )
      )
    }

    data <- get_hash_data(con, req$query$hash)

    res$json(data)
  }
}