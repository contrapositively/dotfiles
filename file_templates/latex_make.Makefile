TEX_FILES = $(shell find . -maxdepth 1 -type f -name '*.tex' )
PDF_FILES = $(TEX_FILES:.tex=.pdf)

.PHONY: all
all: $(PDF_FILES)

%.zip: $(PDF_FILES)
	@echo "- Zipping $@..."
	@zip $@ $(PDF_FILES) -q

%.pdf: %.tex
	@echo "- Making $@..."
	@latexmk -interaction=nonstopmode $< >> /dev/null

tidy: $(PDF_FILES)
	@latexmk $(TEX_FILES) -c >> /dev/null

clean:
	@latexmk $(TEX_FILES) -C >> /dev/null
