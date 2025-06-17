VERSION := $(shell jq -r .version package.json 2>/dev/null || echo "0.0.0")
DATE := $(shell date +%F)
BASEURL := /tway.dev

SRC_MD := demo/index.md
TEMPLATE := demo/template.html
CSS := --css src/reset.css --css src/index.css

POSTS := $(wildcard posts/*.md)
POST_HTML := $(patsubst posts/%.md,dist/posts/%.html,$(POSTS))
POST_CSS := --css $(BASEURL)/src/reset.css --css $(BASEURL)/src/index.css

# Default target
all: build

.PHONY: all clean build

build: dist/index.html $(POST_HTML)

# Ensure dist/ and dist/posts/ exist
dist:
	mkdir -p dist

dist/posts:
	mkdir -p dist/posts

# Build main index.html
dist/index.html: $(SRC_MD) $(TEMPLATE) Makefile | dist
	pandoc --toc -s $(CSS) -Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

# Build posts/*.html into dist/posts/
dist/posts/%.html: posts/%.md $(TEMPLATE) Makefile | dist/posts
	pandoc -s $(POST_CSS) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

clean:
	rm -rf dist