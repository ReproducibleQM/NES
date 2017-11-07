all: reviewer_response.pdf diff.pdf
	pdflatex diff.tex
	pdftk diff.pdf reviewer_response.pdf cat output stacheleketal2017_revised.pdf

pre_response.pdf: pre_response.tex
	pdflatex pre_response.tex
	bibtex pre_response.aux
	pdflatex pre_response.tex

post_response.pdf: post_response.tex
	pdflatex post_response.tex
	bibtex post_response.aux
	pdflatex post_response.tex

diff.pdf: pre_response.pdf post_response.pdf
	latexdiff pre_response.tex post_response.tex > diff.tex
	pdflatex diff.tex
	bibtex diff.aux
	pdflatex diff.tex
	pdflatex diff.tex

reviewer_response.pdf: reviewer_response.tex
	pdflatex reviewer_response.tex