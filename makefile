check: document
	Rscript -e "devtools::check()"

document: css
	Rscript -e "devtools::document()"

css:
	npm run css-build

run: css
	Rscript app.R
