VERSION := $(shell jq -r .version package.json 2>/dev/null || echo "0.0.0")
DATE := $(shell date +%F)
BASEURL := 

SRC_MD := demo/index.generated.md
TEMPLATE := demo/template.html
CSS := --css src/reset.css --css src/index.css

POSTS := $(shell find posts -name '*.md' -type f)
POST_HTML := $(patsubst posts/%.md,dist/posts/%.html,$(POSTS))
POST_CSS := --css $(BASEURL)/src/reset.css --css $(BASEURL)/src/index.css

ALL_POSTS_SRC := posts/index.generated.md
ALL_POSTS_HTML := dist/posts/index.html

RESUME_SRC := resume/index.md
RESUME_HTML := dist/resume/index.html
RESUME_CSS := --css $(BASEURL)/src/reset.css --css $(BASEURL)/src/index.css

# Default target
all: build

.PHONY: all clean build

build: demo/index.generated.md dist/index.html $(POST_HTML) $(RESUME_HTML) $(ALL_POSTS_HTML) dist/src

# Ensure dist/ and dist/posts/ exist
dist:
	mkdir -p dist

dist/posts:
	mkdir -p dist/posts

dist/src: src/*
	mkdir -p dist/src
	cp -r src/* dist/src/

# Build main index.html
dist/index.html: $(SRC_MD) $(TEMPLATE) Makefile | dist
	pandoc --toc -s $(CSS) -i $< -o $@ --template=$(TEMPLATE)

# Build posts/*.html into dist/posts/
dist/posts/%.html: posts/%.md $(TEMPLATE) Makefile
	mkdir -p $(@D)
	pandoc -s $(POST_CSS) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

$(ALL_POSTS_HTML): $(ALL_POSTS_SRC) $(TEMPLATE) Makefile | dist/posts
	pandoc -s $(POST_CSS) -Vdate=$(DATE) -i $< -o $@ --template=$(TEMPLATE)

demo/index.generated.md: $(POSTS) demo/index.md scripts/gen_latest_posts.sh
	scripts/gen_latest_posts.sh

$(ALL_POSTS_SRC): posts/index.md scripts/gen_all_posts.sh $(POSTS)
	scripts/gen_all_posts.sh

$(RESUME_HTML): $(RESUME_SRC) $(TEMPLATE) Makefile | dist/resume
	pandoc -s $(RESUME_CSS) -i $< -o $@ --template=$(TEMPLATE)

dist/resume:
	mkdir -p dist/resume

clean:
	rm -rf dist