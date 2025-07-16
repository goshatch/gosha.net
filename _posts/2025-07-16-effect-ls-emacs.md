---
layout: post
title: "Effect: using effect-language-service in Emacs"
date: 2025-07-16 13:31:13 +0100
location: London
categories: ['programming', 'emacs', 'doom', 'effect', 'effect-ts', 'effect-language-service', 'lsp', 'typescript']
summary: "From the We Are Not Worse Than VSCode department"
---
In my last [lsp-related post](/2025/sorbet-emacs), I wrote that I wasn’t a huge fan of static type checking. Well, that’s changed: I’ve tried Haskell (by building [a simple Scheme implementation](https://github.com/goshatch/ploy)), and more recently, as part of a series of job interviews, I learned about [Effect](https://effect.website).

The JavaScript Extended Universe has never been my favourite part of the programming world, but Effect has forced me to reconsider. The library (think missing stdlib for TypeScript, or Haskell-but-make-it-TypeScript) is taking the TypeScript world by storm, and if you're frustrated with JS/TS, it's worth a look.

## Preparation

Effect comes with a [Language Service](https://github.com/Effect-TS/language-service), packaged as a plugin to `typescript-language-server`. Getting it to work is straightforward in VSCode, but needs some extra steps in Emacs.

Follow that project README by installing the `@effect/language-service` package to your dev dependencies, and adding the relevant plugin configuration to your `tsconfig.json` file.

## Getting it to work in Emacs

The Emacs typescript LSP unfortunately doesn’t load its plugins configuration directly from `tsconfig.json` (why?), but instead looks into a variable called `lsp-clients-typescript-plugins`, which contains a plist of plugins to load.

It’s possible to configure this on a per-project basis by adding a `.dir-locals.el` file at the root of your project. For `effect-language-service`, it would contain something like this:

```elisp
((typescript-mode
  . ((eval .
           (setq-local
            lsp-clients-typescript-plugins
            (let ((root (project-root (project-current))))
              (when root
                (vector
                 (list :name "@effect/language-service"
                       :location (expand-file-name
                                  "node_modules/@effect/language-service"
                                  root))))))))))
```

What’s happening here:

1. When the `typescript-mode` is activated in this project,
2. We set the buffer-local version of the `lsp-clients-typescript-plugins` variable
3. To a vector that contains one plist that specifies the name of the plugin and its location

After adding this `.dir-locals.el` file to your project, revert a project buffer (`M-x revert-buffer`) for the file to be picked up by Emacs, then restart the LSP workspace (`M-x lsp-workspace-restart`).

Enjoy the [Effect-specific features](https://github.com/Effect-TS/language-service?tab=readme-ov-file#provided-functionalities) in Emacs!

<figure>
<img src="/assets/images/posts/2025/effect-ls-emacs/emacs-screenshot.png" alt="The effect-language-service in action in Emacs" />
<figcaption><code>effect-language-service</code> picking up a botched Effect</figcaption>
</figure>
