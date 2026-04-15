# Taskie Web

<p>
  <img src="https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white" alt="HTML5" />
  <img src="https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white" alt="CSS3" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/PWA-5A0FC8?logo=pwa&logoColor=white" alt="PWA" />
</p>

## Overview

The Taskie web presence is a static landing page built with **pure HTML5, CSS3, and vanilla JavaScript** — zero external dependencies. It serves as the public-facing website with a feature showcase, Google Play download CTA, and legal documentation (Privacy Policy, Terms & Conditions). Deployed to a Hetzner VPS behind Nginx.

## Tech Stack

- **HTML5** — semantic markup (`<header>`, `<section>`, `<footer>`, `<nav>`)
- **CSS3** — custom properties, Grid, Flexbox, animations, transitions
- **Vanilla JavaScript** — Intersection Observer API, event handling
- **No frameworks, no libraries, no CDN requests**

## Features

- **Hero section** — animated app icon with gradient text heading and Google Play CTA
- **Feature showcase** — 4 cards (Workspaces, Tasks & Goals, Leaderboard, Team Collaboration) with scroll-triggered animations
- **Responsive layout** — CSS Grid with `repeat(auto-fit, minmax(250px, 1fr))` for automatic column adjustment
- **Legal pages** — Privacy Policy and Terms & Conditions with consistent styling
- **Google Play link** — CTA button in hero section

## Design

### CSS Architecture

- **CSS Custom Properties** for theme consistency across all pages:
  - Primary: `#6a5acd` (indigo/purple)
  - Accent: `#00d2d3` (cyan)
  - Text: `#2d3436` (dark gray)
  - Background: `#f9f9f9` (light gray)
- **Mobile-first** responsive approach with a `768px` breakpoint
- **CSS Grid** for feature card layout — auto-fit handles 1-4 columns based on viewport width
- **Flexbox** for header and alignment
- **BEM-like** class naming for maintainability

### Typography

- System font stack: Segoe UI, Tahoma, Geneva, Verdana, sans-serif
- Hero heading: 3rem (desktop) → 2.2rem (mobile)
- Body: 1rem with 1.6 line-height

## Animations & Interactivity

| Animation | Trigger | Implementation |
|-----------|---------|---------------|
| **fadeIn** | Page load | Hero section fades in over 1 second |
| **fadeInUp** | Scroll into view | Feature cards animate upward with opacity transition (0.8s) |
| **Button hover** | Mouse hover | Lift effect (`translateY(-3px)`) with expanding box shadow |
| **Card hover** | Mouse hover | Lift effect (`translateY(-5px)`) with primary border color |

All animations use **hardware-accelerated properties** (`transform`, `opacity`) to avoid layout thrashing. Scroll-triggered animations use the **Intersection Observer API** at a 10% visibility threshold — no scroll event listeners, no jank.

## PWA & Cross-Platform

- **Web App Manifest** (`site.webmanifest`) — enables "Add to Home Screen" with standalone display mode
- **Multi-resolution favicons** — 16x16, 32x32, 180x180 (Apple Touch), 192x192, 512x512 (PWA splash)
- **Android App Links** — `.well-known/assetlinks.json` verifies ownership for 3 app variants (dev, production with 2 signing configs), enabling deep links from the web to the native Flutter app

## Performance

- **Zero dependencies** — no external JavaScript or CSS libraries, no CDN requests
- **Embedded resources** — CSS and JS are embedded in each HTML file (one fewer HTTP request per resource)
- **Single HTML file per page** — entire page renders from a single server response
- **HTML minification** — the CI/CD pipeline minifies all HTML files with `html-minifier-terser` before deployment (whitespace collapsing, comment removal, inline CSS/JS minification)
- **Intersection Observer** — native browser API for lazy animation, replacing traditional scroll event listeners

## Design Decisions

**Why vanilla HTML/CSS/JS over a framework** — a landing page with 3 static pages does not need React, Vue, or any framework. Zero dependencies means instant page loads, no build tooling complexity, no JavaScript bundle to parse, and no maintenance burden from framework version updates. The result loads faster than any framework-based equivalent.

**Why embedded styles over external CSS files** — with all CSS in the HTML file, the browser renders the complete styled page from a single HTTP response. For a small landing page, this eliminates the render-blocking CSS request that an external stylesheet would introduce.

**Why Intersection Observer over scroll events** — the Intersection Observer API is a native browser API designed specifically for detecting element visibility. Unlike scroll event listeners, it runs off the main thread, doesn't fire continuously during scrolling, and requires no debouncing or throttling logic.
