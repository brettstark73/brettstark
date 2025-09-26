# Repository Guidelines

## Project Structure & Module Organization

This Hugo site keeps rich content bundles in `content/` (each post/page keeps media in a sibling `images/` folder) and archetype starters in `archetypes/`. Layout overrides live in `layouts/`, extending the vendored `themes/hugo-papermod/` theme. Custom CSS sits in `assets/css/extended/` for Hugo Pipes to process, while passthrough files (favicons, large media) reside in `static/`. Build artefacts belong in `public/` and `resources/` and are regenerated on demand.

## Build, Test, and Development Commands

Use `npm install` (Node 20+ required; Volta and `.nvmrc` pin versions) to set up tooling. `npm run dev` starts `hugo server -D` with drafts and live reload; `npm run dev:full` disables fast render for full rebuilds. `npm run build` runs `hugo --gc --minify` and produces the deployable site under `public/`.

## Coding Style & Naming Conventions

Prettier enforces 2-space indentation, single quotes, and 80-character wraps—run `npm run format` before large commits. JavaScript/TypeScript that lands in `assets/` follows ESLint recommended defaults. CSS in `assets/` respects `stylelint-config-standard`; prefer semantic class names that map cleanly to PaperMod blocks. Slugs are kebab-case (`content/posts/outbound-flight/index.md`), and front matter dates stay ISO (`YYYY-MM-DD`).

## Testing & Quality Checks

Run `npm run format:check`, `npm run lint:scripts`, and `npm run lint:styles` locally; each command skips gracefully when no matching files exist. GitHub Actions mirrors this via `.github/workflows/quality.yml` using Node 20 and Hugo 0.150.0. Add functional or visual regression tests alongside features as the site evolves.

## Commit & Pull Request Guidelines

Follow `Type: summary` commit subjects (e.g., `Content: import 2020 recap`, `Fix: adjust header tagline`) capped at 72 characters. Group related edits per commit and document migrations or media handling in the body. Pull requests should describe the change, note any new large assets or LFS requirements, include screenshots for visual tweaks, and link tracking issues. Ensure CI is green before requesting review.

## Tooling & Deployment Notes

Install `git-lfs` locally; Husky hooks enforce this on `post-merge` and `pre-push`. Vercel deploys via `vercel.json`; update DNS for `brettstark.com` and keep `HUGO_VERSION` aligned. Secrets (API keys, third-party tokens) belong in Vercel or GitHub Action secrets—never in `hugo.toml` or content front matter.
