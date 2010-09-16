#!/usr/bin/make -f

XSLTPARAMS = --xinclude -o output/regular-expressions.html \
	--stringparam make.single.year.ranges 0 \
	--stringparam html.stylesheet "/loud.css"
HTMLSTYLESHEET = /usr/share/xml/docbook5/stylesheet/docbook5/html/docbook.xsl
DOCUMENT = regular-expressions
OSTYPE := $(shell uname -s)

# OS X?
ifeq ("$(findstring Darwin, $(OSTYPE))", "Darwin")
	SED = sed -E
	FIND = find . -E
# Assume GNU
else
	SED = sed -r
	FIND = find . -regextype posix-extended
endif

all: clean

html:
	xsltproc $(XSLTPARAMS) $(HTMLSTYLESHEET) $(DOCUMENT).xml

pdf:
	dblatex -o output/$(DOCUMENT).pdf -P latex.class.options=11pt -P term.breakline=1 $(DOCUMENT).xml

docs: html pdf

clean:
	$(FIND)  \( -regex "^[.]?(.+)\~$$" -o -regex "./[.]?#.*#" \) -delete
	rm -fR output/*
