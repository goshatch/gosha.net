---
layout: post
title: "Out with CI, in with a Makefile"
date: 2025-02-23 05:53:51 +0000
location: London
categories: ['meta', 'makefile', 'overengineering', 'technical', ’simplify’]
summary: "I really do not need to cosplay as a Big Engineering Organisation"
---

Recently, I got a bit fed up with overcomplicating things in my computing life, and [changed](https://github.com/goshatch/gosha.net/commit/e39eb4324b78ab89aee5b699548a2761ca921c71) the way this website is deployed.

I previously used GitHub Actions, a continuous integration pipeline, to watch for changes in the `main` branch of this website’s [GitHub repo](https://github.com/goshatch/gosha.net). Once a change was made, a process would start that would:

- Spin up an Ubuntu virtual machine
- Check out my website’s Git repository
- Install Ruby
- Setup SSH keys needed to access the remote server
- Install the dependencies needed to build the site
- Build the site
- Deploy it to my server with `rsync`

This process would repeat each time a new commit was pushed to `main`, with the virtual machine being spun up, set up, and torn down: a data centre come to life for 30 seconds just to copy some files over.

It doesn’t have to be this way! Back in the _olden days_, we used to deploy by copying stuff over to the server from our machines using an FTP client, and this is still a viable method! If I think about it, the GitHub Actions deployment method appeals to the nerd in me by making things reproducible and *technically* enabling me to deploy stuff from anywhere[^1], but in reality I’m only ever working on my website from the comforts of my own computer.

I’m not running an Important Engineering Organisation here, and I don’t need to cosplay as one: I can choose to use simple tools for simple tasks.

I’ve been [using a Makefile](https://github.com/apossiblespace/parts/blob/main/Makefile) in [Parts](https://parts.ifs.tools), the IFS parts mapping tool we’re building, and it’s been a great simple way to manage project tooling from a single convenient interface. So I decided to use one for this website as well. Here it is:

```makefile
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
```

It does a couple of interesting things:
- It abstracts away the Jekyll `serve` command options which I can never remember behind a `serve` target
- It lets me create draft posts with appropriate metadata from the command line, instead of copying an existing post and changing dates (I often mess this up)
- It automatically generates the git metadata used at the bottom of the [Colophon](/colophon) page without running an external script, like the GitHub Actions setup did

And finally, it deploys using `rsync` (a not-so-modern, more secure equivalent to FTP), in exactly the same way as the GitHub Actions setup did. The difference is: my laptop is already setup with all the dependencies and with SSH keys, and I don’t need to spin up and tear down a VM each time I want to publish something. Publishing a change is actually quicker: I just type `make yeet` into the terminal I already have open, and a few seconds later the site is deployed, with instant feedback.

Just as important: using an ancient technology like `make` in 2025 (the age of `package.json` scripts) feels positively aesthetically _subversive_, and makes me cackle a little bit each time I type the command in.

Let’s say it together: Enterprise Brain, no! Simple tools, yes!

[^1]: For example, by editing something in the website repo using the GitHub mobile app: I have not done this even once in the four years this version of the website has been online.
