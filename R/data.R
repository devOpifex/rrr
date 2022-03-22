#' GET data
#' 
#' Endpoint to retrieve data on a specifc URL.
#' 
#' @param con Database connection.
#' 
#' @keywords internal
data_get <- \(con) {
  \(req, res) {

    # this is in /profile
    # the user must be authenticater
    # this should therefore never happen
    # (only authenticated user can make request)
    # but if it does, we reject.
    if(!req$authenticated) {
      return(
        res$json(
          list(
            error = "User not authenticated"
          )
        )
      )
    }

    # the query should include a hash
    # in the event something went wrong we 
    # just exit here
    if(length(req$query$hash) == 0L) {
      return(
        res$json(
          list(
            error = "Missing path"
          )
        )
      )
    }

    # get data for specific /path (hash)
    data <- get_hash_data(con, req$query$hash)

    res$json(data)
  }
}