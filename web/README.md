# Taskie Web

<p>
  <img src="https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white" alt="HTML5" />
  <img src="https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white" alt="CSS3" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black" alt="JavaScript" />
</p>

## Overview

A static [landing page](https://taskieapp.xyz) built with **pure HTML5, CSS3, and vanilla JavaScript** — zero external dependencies. It serves two purposes: a public-facing website with a feature showcase and legal documentation, and a **fallback destination** for non-deep-link URLs on the app's domain (when a link that isn't a registered deep link is opened on mobile, the user lands here instead of a blank page). Deployed to a Hetzner VPS behind Nginx.

## Tech Stack

- **HTML5** — semantic markup (`<header>`, `<section>`, `<footer>`, `<nav>`)
- **CSS3** — custom properties, Grid, Flexbox, animations, transitions
- **Vanilla JavaScript** — Intersection Observer API, event handling
- **No frameworks, no libraries, no CDN requests**

## Features

- **Hero section** — animated app icon with gradient text heading and Google Play CTA (coming soon placeholder)
- **Feature showcase** — 4 cards with scroll-triggered fade-in animations via Intersection Observer
- **Responsive layout** — CSS Grid with `repeat(auto-fit, minmax(250px, 1fr))`, mobile-first with 768px breakpoint
- **Legal pages** — Privacy Policy and Terms & Conditions
- **Android App Links** — `.well-known/assetlinks.json` verifies ownership for 3 app variants (dev, production with 2 signing configs), enabling deep links from the web to the native Flutter app
- **PWA manifest** — `site.webmanifest` with multi-resolution favicons (16px–512px)

## Design Decisions

**Why vanilla HTML/CSS/JS over a framework** — a simple landing page does not need React or Vue. Zero dependencies means instant page loads, no build tooling, and no maintenance burden from framework updates.

**Why embedded styles over external CSS files** — with all CSS in the HTML file, the browser renders the complete styled page from a single HTTP response, eliminating a render-blocking CSS request.

**Why Intersection Observer over scroll events** — native browser API designed for detecting element visibility. Runs off the main thread, doesn't fire continuously during scrolling, and requires no debouncing.
