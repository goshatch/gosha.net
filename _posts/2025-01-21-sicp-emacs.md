---
layout: post
title: "SICP in Doom Emacs"
date: 2025-01-21 15:00:00 +0000
location: London
categories: ['sicp', 'emacs', 'doom', 'programming', 'org-mode', 'scheme']
summary: "Setting up Doom Emacs, Geyser, and Racket for working through the exercises in Structure and Interpretation of Computer Programs."
featured_image: /assets/images/posts/2025/sicp-emacs/sicp.jpg
---

<figure>
<img src="/assets/images/posts/2025/sicp-emacs/emacs-screenshot.jpg" alt="A screenshot of Emacs setup for SICP study" />
<figcaption>My Doom Emacs setup for SICP</figcaption>
</figure>

One of the things I would like to do this year is to improve my foundations in computer science. In order to accomplish this, I’m working my way through the fascinating “[Structure and Interpretation of Computer Programs](https://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs)”, by Abelson, Sussman, and Sussman. The book is freely available online in a variety of formats, including [HTML](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-4.html#%25_toc_start) and a beautifully laid out and formatted [PDF](https://web.mit.edu/6.001/6.037/sicp.pdf) ([GitHub repo](https://github.com/sarabander/sicp-pdf)).

Here is the way I’ve setup [Doom Emacs](https://github.com/doomemacs/doomemacs) on my Mac for studying this book, experimenting with code, and taking notes (with `org-mode`). I had to piece together this setup from various sources online, this is what’s worked for me.

---

## Install Racket and the SICP lang

The programming language used in SICP is MIT Scheme, but it has significantly evolved since the book was written. Luckily, [Racket](https://racket-lang.org), a modern Scheme implementation, supports custom DSLs, [one of which](https://docs.racket-lang.org/sicp-manual/index.html) can be used to emulate the version of Scheme used in SICP.

### Racket

Install Racket via Homebrew[^1]. I chose the `minimal-racket` formula, as prefer to write code in Emacs and did not want to install [DrRacket](https://docs.racket-lang.org/drracket/index.html) (an IDE).

```sh
$ brew install minimal-racket
```

This will make the `racket` command available, which will open a Racket REPL.

### SICP language

Racket provides “[SICP Collections](https://docs.racket-lang.org/sicp-manual/index.html)”, which make Racket compatible with the MIT Scheme implementation that was in use at the time of the book’s publication. When you’re not using DrRacket, this can be installed via the Racket package manager, which you’ve conveniently also installed in the previous step:

```sh
$ raco pkg install sicp
```

Once this is installed, we have everything we need on the system side, and it’s time to move on to the Emacs side.

## Configure your Doom Emacs

I’m using Doom Emacs, so these steps assume you do too. If you’re using your own config, I would recommend that you check out Konstantinos Chousos’s [SICP in Emacs](https://kchousos.github.io/posts/sicp-in-emacs/) post, which also has some useful additional info, such as how to read the book in the Texinfo format.

We will install support for Racket, create an org file for our notes, and make sure that the code blocks of our org file use the SICP language rather than plain Racket.

### init.el

In your Doom Emacs `init.el` file (located in your Doom config directory, in my case at `~/.config/doom/init.el`), uncomment the `scheme` line under the `:lang` header, and add the `+racket` flag to it[^2], like this:

```elisp
;; ~/.config/doom/init.el
(scheme +racket) ; a fully conniving family of lisps
```

Reload your config by hitting `SPC h r r` (or restarting Emacs, if you’re so inclined). This will install [Geiser](https://github.com/emacsmirror/geiser) along with [geiser-racket](https://github.com/emacsmirror/geiser-racket), which will allow you to open a Racket REPL, evaluate Racket code blocks in Org, etc.

### Geiser

Optionally, we need to be able to tell Geiser about the fact that we want the SCIP lang to be enabled when we open a Racket REPL. This can be accomplished by adding the following line to `~/.racket-geiser`:

```scheme
;; ~/.racket-geiser
(require sicp)
```

This is optional. We might not want to do this if we work with Racket code outside of the SICP context, which I don’t, so I set it up this way. 

If we don’t do this, we need to add `(require sicp)` on the first line of each of our Org code blocks that use SICP syntax. Alternatively, if we are working with Racket source files rather than Org code blocks, we need to add `#lang sicp` as the first line of each file in which we wish to work on SICP code.

### Org mode

I take notes in Org mode. The main benefit of doing this is that I can insert code blocks that can be evaluated inline by pressing `C-c`, for example as such:

```scheme
#+begin_src scheme
(define (square x) (* x x))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)
#+end_src

#+RESULTS:
: 136
```

For this to work properly, I have added the following header to the top of my notes file:

```
#+property: header-args:scheme :cmd "racket" :results value :session sicp
```

This tells Org the following things about how to work with Scheme code blocks:
- Use the command `racket` to start the underlying REPL
- Use the value of the last expression in the `#+RESULTS:` block
- Keep a REPL session named “sicp” running for this document

This last option means that blocks are not isolated, so a procedure defined in one block will be also available in all the following blocks, and will not need to be re-defined each time. Convenient!

This should be enough to get you started with SICP in Doom Emacs. Please let me know if you run into any trouble, or if any of these instructions can be improved! Godspeed.

[^1]: If you’re not on macOS, please refer to the Racket website for [installation instructions](https://docs.racket-lang.org/getting-started/index.html) for your operating system.
[^2]: Doom also provides [a “Racket” module](https://github.com/doomemacs/doomemacs/blob/master/modules/lang/racket/README.org), which can lead to confusion. For our purposes, we can leave this module disabled, and rely on `(scheme +racket)` instead, as our interest is in using Racket to emulate MIT Scheme, rather than in its many other features.
