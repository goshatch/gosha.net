---
layout: post
title: "Blog Questions Challenge"
date: 2025-01-31 15:00:00 +0000
location: London
categories: ['meta', 'blogging']
summary: "Answering questions on the why and how of this here website."
---

I’ve been tagged by [Naz Hamid](https://nazhamid.com/journal/blog-questions/) to answer the Blog Questions challenge! So here goes:

### Why did you start blogging in the first place?

I started blogging “properly” only fairly recently, since the [first iteration](/2020/hello-again-world) of this version of my website, which I’ve built in 2020. The goal was to document the stuff I work on, but it became a much looser collection of writing, which I’m not unhappy with.

I had several false starts in blogging over the previous decades, which didn’t stick mainly because I had failed to look for my own voice, but was rather trying to emulate the early bloggers whom I admired, and, as a result, wrote for what I imagined _their_ audience might want to read. Never a good idea. This time around, I’m writing for myself first of all, so it is much easier to keep up the habit.

### What platform are you using to manage your blog and why did you choose it?

[This website](/colophon) is static: plain HTML, CSS, and images, without any dynamic content. I use [Jekyll](https://jekyllrb.com/) to generate it from a bunch of templates and Markdown files. The site is stored in [a Git repository over at GitHub](https://github.com/goshatch/gosha.net). When I push changes to it, GitHub Actions generates the complete website, and uploads it to my server, which is a basic VPS hosted at Hetzner and running OpenBSD (see [this post](https://sive.rs/openbsd) from Derek Sivers on why OpenBSD is a solid choice). The GitHub bit is all optional, though: I could as easily build the site on my laptop and publish it directly to my server.

Back when I started using Jekyll, it was the default option for static site generators (although there are many other options now!), and I also happened to be comfortable with Ruby, the language Jekyll is written in, so sticking with it and extending it over the years to fit my needs has been a natural choice.

I got interested in static site generators because I was drawn to the simplicity of storing my writing, photos, etc, as just regular files on my hard drive, rather than being tied down in a database somewhere. I’ve since started to apply this principle to other areas of my computing life, and I now generally prefer to store my work and media in simple formats that I know I would be able to open again in a decade or more.

### Have you blogged on other platforms before?

I’ve tried many: Wordpress, Movable Type, Textpattern, Posterous, Tumblr, Squarespace, just to name a few. None of them allowed me the simplicity and control that a static site generator provides, though, which also contributed to each iteration being short-lived. 

### How do you write your posts? For example, in a local editing tool, or in a panel/dashboard that’s part of your blog?

I write most of my blog posts in my text editor, [Emacs](https://www.gnu.org/software/emacs/). For longer pieces, I sometimes use [iA Writer](https://ia.net/writer), for its focus mode, and then import it to Emacs to add metadata and the like. Emacs is my preferred program for working with text: I write code with it, [study with it](/2025/sicp-emacs/), use it for planning projects, [knowledge management](https://www.orgroam.com/), and more.

I keep a text file with ideas for blog posts, but in practice I rarely refer to it, and each new post tends to be in response to some external impulse that nudges me to write about it.

### When do you feel most inspired to write?

As a parent to a 2.5 year old, I rarely have the luxury to rely on inspiration coming to me. I tend to write when I have something specific I want to write about, AND I have some time that is not earmarked for something else, which is increasingly rare.

### Do you publish immediately after writing, or do you let it simmer a bit as a draft?

It really depends on the post. With some posts, I can be quite spontaneous, but others sit in drafts for a while, and end up being rewritten a few times. I’ve also experimented with asking people to help editing a post, which turned out to be a positive experience.

### What are you generally interested in writing about?

I want to use this website as a [notebook](https://piperhaywood.com/about/), to keep notes about my various projects and the things that interest me. I don’t think I am succeeding in that yet, but that’s what I’m striving for.

### Who are you writing for?

Because I try to make this blog an extension of my projects and interests, I write for myself, first of all. Hopefully, someone else will find some of this interesting, as well, but I am not attempting to write for any specific audience. 

### What’s your favorite post on your blog?

Maybe [the post about my name](/2023/name). It took me a while to write, and I collaborated with a few smart people to edit it. I’m happy with how it turned out.

### Any future plans for your blog? Maybe a redesign, a move to another platform, or adding a new feature?

Messing with the website’s design and adding new features is an excellent way to procrastinate on the writing!

That being said… even though I like Jekyll, I have a few new features in mind for my website that would stretch its capabilities a fair bit, so I’ve been toying around with the idea of writing my own static site generator (which is a nerd rite of passage of sorts). I started building [something](https://github.com/goshatch/homestead) while exploring Common Lisp last year, but it is still unfinished.

### Tag ‘em.

I would love to read the answers to these questions from [Pirijan](https://pketh.org/), [Cabel](https://cabel.com), [anh](https://anhvn.com), [Thomas](https://thomasorus.com), and [Vlad](https://vlad.website/)!

Thank you for reading!
