data_get <- \(con) {
  \(req, res) {
    print(req$cookie)
    res$json(cars)
  }
}