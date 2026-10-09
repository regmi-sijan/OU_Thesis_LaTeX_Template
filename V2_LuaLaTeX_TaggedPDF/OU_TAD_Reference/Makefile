###############################################################################
# Default LaTeX makefile
# Samuel Jero <sj323707@ohio.edu>
#
# LuaLaTeX is used because LaTeX's PDF tagging (figure alt text) is designed
# for it. -shell-escape lets embedfigurefonts.sty run Ghostscript, which embeds
# every font used inside PDF/EPS figures (Overleaf enables it by itself).
###############################################################################
TEXFILE:=main
OUTPUT:=main.pdf
LATEX:=lualatex -shell-escape


all: pdf
	
pdf: 	
	${LATEX} ${TEXFILE}.tex
	bibtex ${TEXFILE}.aux
	${LATEX} ${TEXFILE}.tex
	${LATEX} ${TEXFILE}.tex
	#mv ${TEXFILE}.pdf ${OUTPUT}

clean:
	rm -f *~ *.aux *.dvi *.log *.blg *.bbl *.toc *.lof *.lot *.out *.synctex.gz
	rm -rf fontfixed-figures
