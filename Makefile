.POSIX:
.PHONY: all git-meta yeet serve draft

REMOTE_HOST = bubundel
REMOTE_PATH = /var/www/gosha.net
DRAFT_DIR = _drafts
NOW = $(shell date '+%Y-%m-%d %H:%M:%S %z')
YEAR = $(shell date '+%Y')

all: yeet

git-meta:
	@mkdir -p _data
	@git log -1 --pretty=format:'{ "hash": "%h", "date": "%aI", "subject": "%s", "author": "%aN" }' > _data/git.json

serve:
	bundle exec jekyll serve --drafts --livereload --incremental

draft:
	@mkdir -p _drafts
	@read -p "title: " title; \
	read -p "location: " location; \
	fname=$$(echo "$$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$$//g'); \
	echo "---\nlayout: post\ntitle: \"$$title\"\ndate: $(NOW)\nlocation: $$location\ncategories: []\nsummary: \"\"\nfeatured_image: /assets/images/posts/$(YEAR)\n---\n" > "$(DRAFT_DIR)/$$(date +%Y-%m-%d)-$$fname.md"

yeet: git-meta
	bundle exec jekyll build
	rsync -rvlh --progress --delete _site/ $(REMOTE_HOST):$(REMOTE_PATH)
