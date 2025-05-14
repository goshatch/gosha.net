---
layout: post
title: "Ruby: sane sorbet-ls setup in Emacs"
date: 2025-05-14 21:43:13 +0100
location: London
categories: ['programming', 'emacs', 'doom', 'sorbet', 'sorbet-ls', 'lsp', 'ruby', 'rails']
summary: "Conditionally loading Sorbet LSP in Emacs with Doom and lsp-mode"
---
I’m generally not a huge fan of static type checking, so I do not use [Sorbet](https://sorbet.org/) in my personal Ruby and Rails projects. At work, however, we do use it: our project includes Sorbet in its `Gemfile`.

This creates a situation where I would sometimes have two projects open in Emacs: one with Sorbet, and one without. When working on the project that does not use Sorbet, each new open buffer would try to start `sorbet-ls`, and fail, complaining about not being able to find the `srb` executable in the project bundle.

It’s of course possible to disable the `lsp-mode` client for `sorbet-ls` entirely, by adding it to `lsp-disabled-clients`, but this will also disable it in the project that does use Sorbet.

Below is the workaround I’ve come up with, I publish it here in the hopes it will be useful for someone else.

1. We disable the default `lsp-mode` client config for `sorbet-ls` so it won’t auto-start everywhere.
2. We create a function that checks whether the project associated with the current buffer uses Sorbet. It checks for the presence of a `sorbet` directory, and for any mention of Sorbet in the `Gemfile.lock` file.
3. We register a new LSP client that will start in all ruby buffers, but only if that buffer belongs to a project that uses Sorbet.

Please note that I’m using Doom Emacs (which provides the `after!` macro), and `lsp-mode` rather than `eglot`.

```elisp
(after! lsp-mode
  (require 'lsp-sorbet)
  (add-to-list 'lsp-disabled-clients 'sorbet-ls)

  (defun gt/project-has-sorbet-p ()
    "Does this project use Sorbet?"
    (or (locate-dominating-file default-directory "sorbet")
        (when-let* ((root (locate-dominating-file default-directory "Gemfile.lock"))
                    (gemfile-lock (expand-file-name "Gemfile.lock" root)))
          (with-temp-buffer
            (insert-file-contents gemfile-lock)
            (search-forward-regexp "^ *sorbet \\|^ *sorbet-static " nil t)))))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       (when (gt/project-has-sorbet-p)
                         (if (file-exists-p "Gemfile")
                             '("bundle" "exec" "srb" "tc" "--lsp")
                           '("srb" "tc" "--lsp")))))
    :activation-fn (lambda (filename _mode)
                     (and (eq major-mode 'ruby-mode) (gt/project-has-sorbet-p)))
    :priority -1
    :add-on? t
    :server-id 'gt/sorbet-ls)))
```

Please adapt as needed, and do let me know if you’ve come up with a simpler and/or more elegant solution for this problem.
