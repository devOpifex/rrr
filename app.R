pkgload::load_all()

con <- DBI::dbConnect(RSQLite::SQLite(), "rrr.sqlite3")

setup_database(con)

app <- build(con)
app$on_stop <- \(...) {
  DBI::dbDisconnect(con)
}
app$start()
