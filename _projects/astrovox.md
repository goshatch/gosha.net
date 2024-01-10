---
layout: project
title: ASTROVOX
timespan: 2023&ndash;
categories: ['Software']
featured_image: /assets/images/projects/astrovox/featured.gif
date: 2024-01-09
---
ASTROVOX is an experimental software project aimed at playing with sound
generation.

<div class="video-container">
  <iframe src="https://www.youtube.com/embed/8iqiGaBeByc?si=HHoovh1WyLdKpInI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

The original goal was to write an approximate software emulation of the Roland
[Juno-60](https://en.wikipedia.org/wiki/Roland_Juno-60) synthesizer (as used by
two of my favourite musicians, Olafur Arnalds and Nils Frahm), but as the
project progressed, it took on a life of its own and became much more open
ended.

ASTROVOX is written in C, and aims at being as simple as possible, with a
minimum number of dependencies.

This project is a “play project”: sound generation is a brand new domain to me,
I’ve last worked with C in uni in 2005, so I have no hopes of a “good enough”
outcome — only of exploring and enjoying the process.

- - -

### Roadmap

The following features are planned for a first release:

- [X] Sine, square, saw, pulse waveform generators
- [X] ADSR envelope
- [X] Low- and high-pass filter
- [X] Chorus functionality
- [ ] Modulation, LFOs
- [ ] Multiple voices
- [ ] Modular design allowing for custom signal processing chains
- [ ] Scripting

### Download

ASTROVOX is currently in development, and no official release is available yet.
The source code is available [on Sourcehut](https://git.sr.ht/~gosha/astrovox).

Bug reports and patches are very welcome, and can be submitted via my [public
inbox](https://lists.sr.ht/~gosha/public-inbox) on Sourcehut.
