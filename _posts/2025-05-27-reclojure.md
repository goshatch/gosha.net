---
layout: post
title: "reClojure 2025"
date: 2025-05-27 09:48:53 +0100
location: London
categories: ['clojure', 'conference', 'programming', 'socialising', ’reflection’, 'london']
summary: "Reflecting on my first Clojure conference"
featured_image: /assets/images/posts/2025/reclojure/featured.png
---

<figure>
<img src="/assets/images/posts/2025/reclojure/badge.jpg" alt="A conference attendee badge on a desk" />
<figcaption>My reClojure 2025 badge</figcaption>
</figure>

I went to my first Clojure conference yesterday — my first tech conference since Rails Conf 2012. It was [reClojure](https://www.reclojure.org/) in London, and it made me _think_.

Talks were generally really good, but a couple landed particularly well.

[Replicant](https://replicant.fun) creator Christian Johansen’s talk hit close to home: I’m building [Parts](https://parts.ifs.tools), and he demoed what UI development (with Replicant) can look like when one takes functional programming seriously[^1]. He also introduced a couple of interesting tools, including [Portfolio](https://github.com/cjohansen/portfolio), a Storybook-like tool for Clojure, letting you test components visually and separately from each other.

I can’t use Replicant or Portfolio _yet_, as Parts is deep in the React ecosystem with [React Flow](https://reactflow.dev) holding the whole thing together, but the talk was a needed reminder: modern UI doesn’t have to mean React and its complexities. Simplicity and testability can win.

Another talk I liked was on brain/computer interfaces, by [Lorelai Lyons](https://lorelailyons.me/), who cracked open a field that felt like sci-fi to me via an impressive growth mindset. “You can just do things”, was my takeaway, “and share what you do, and be open about what you don’t know, and be excited about it all”. I wasn’t expecting to leave thinking about brain/computer interfaces, but Lorelai’s talk put them on my radar. She made the field feel accessible, like something weird and wonderful I could just start engaging with. That felt rare and freeing!

---

On the way home from the conference, I made this post on my socials:

{% capture toot_content %}
<p>A day at <a href="https://merveilles.town/tags/reClojure" class="mention hashtag" rel="tag">#<span>reClojure</span></a>, listening to inspiring talks &amp; talking to inspiring nerds, made me realise just how burnt out I am on the whole field of CRUD-adjacent webdev. I feel I need some kind of reset, to start working on more challenging, more meaningful problems 🤔</p>
{% endcapture %}
{% include mastodon_post.html
   url="https://merveilles.town/@gosha/114574818156410355"
   author="gosha 🏴‍☠️"
   handle="gosha@merveilles.town"
   date="2025-05-26T15:23:02.125Z"
   content=toot_content %}

This wasn’t nothing. Everyone who gave talks (or just showed up) brought this infectious kind of energy, the energy of people who care about their work, deeply. It made me realise that I need a lot more of this energy in my own life.

I’ve been circling this particular kind of burnout for a few years now, trying not to name it. Attending reClojure wasn’t a magic fix for all my problems, but it nudged me in what feels like a positive direction. Maybe that’s the start of doing some things differently.

[^1]: A benefit of a truly functional way to build UI is that everything is a function, and so everything can be tested as such. And indeed, this is a big focus of Replicant and a big part of the appeal to me, as UI testing is often rather brittle.
