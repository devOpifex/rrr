check: document
	Rscript -e "devtools::check()"

document: 
	Rscript -e "devtools::document()"

run:
	Rscript app.R
