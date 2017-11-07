all:
	pdflatex diff.tex

pre_response.pdf:
	pdflatex pre_response.tex
	bibtex pre_response.aux
	pdflatex pre_response.tex

post_response.pdf: 
	pdflatex post_response.tex
	bibtex post_response.aux
	pdflatex post_response.tex

diff.pdf: pre_response.pdf post_response.pdf
	latexdiff pre_response.tex post_response.tex > diff.tex
	pdflatex diff.tex
	bibtex diff.aux
	pdflatex diff.tex
	pdflatex diff.tex

