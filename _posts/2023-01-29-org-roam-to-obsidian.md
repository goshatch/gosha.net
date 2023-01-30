---
layout: post
title: "Importing org-roam notes into Obsidian"
date: 2023-01-29 23:30:00 +0000
location: London
categories: ['programming', 'emacs', 'org-roam', 'notes']
summary: I wrote a script to automate converting a collection of notes created with org-roam to markdown for use in Obsidian.
---
I was recently playing with the idea of moving my collection of [org-roam](https://www.orgroam.com/) notes to [Obsidian](https://obsidian.md/), mainly because I wanted to have easy access to my notes on mobile.

I have about 150 notes in my collection, along with ~250 dailies, so copying everything over by hand was out of the question. I could not find an acceptable ready-made solution, so I wrote a simple Ruby script, that leverages [Pandoc](https://pandoc.org) to do the org to markdown conversion. [The repository is here on GitHub](https://github.com/goshatch/orgroam_to_obsidian).

In the end, though Obsidian seems like a quality piece of software, I love Emacs and org-mode too much, and decided to stay with org-roam. It’s good to know that I am not locked in, though, and that I can choose to export my entire library at any time.
