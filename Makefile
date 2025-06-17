VERSION := $(shell jq -r .version package.json 2>/dev/null || echo "0.0.0")
DATE := $(shell date +%F)

SRC_MD := demo/index.md
TEMPLATE := demo/template.html
CSS := --css src/reset.css --css src/index.css

# Add post support
POSTS := $(wildcard posts/*.md)
POST_HTML := $(POSTS:.md=.html)

# Default target
all: build

.PHONY: all clean build

build: index.html $(POST_HTML)

index.html: $(SRC_MD) $(TEMPLATE) Makefile
	pandoc --toc -s $(CSS) -Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

posts/%.html: posts/%.md
	pandoc -s $(CSS) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

clean:
	rm -f index.html posts/*.html
