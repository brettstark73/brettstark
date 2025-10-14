# brettstark.com — Hugo site

Personal site built with Hugo and the PaperMod theme. Content is organized as page bundles under `content/`, with images placed in a sibling `images/` folder per post.

## Project Structure

- `content/` — posts and pages (each bundle has its own `images/`).
- `archetypes/` — default front matter for new content.
- `layouts/` — layout overrides extending `themes/hugo-papermod/`.
- `assets/` — custom CSS/JS; extended styles in `assets/css/extended/`.
- `static/` — passthrough files (favicons, large media, etc.).
- `themes/hugo-papermod/` — theme as a Git submodule.
- `public/`, `resources/` — build artefacts (generated).

## Prerequisites

- Node.js 20+
- Hugo (extended) installed locally
- Git LFS installed (`git lfs install`)

## Setup

```bash
git submodule update --init --recursive  # theme
npm install                               # tooling
```

## Local Development

- With npm scripts (recommended):
  - `npm run dev` — runs `hugo server -D` with drafts + live reload
  - `npm run dev:full` — full rebuilds (fast render off)

- Direct Hugo (if scripts are not present):
  - `hugo server -D`

## Build

- With npm scripts: `npm run build` (runs `hugo --gc --minify`)
- Direct Hugo: `hugo --gc --minify`

Output is generated under `public/`.

## Quality & Formatting

- `npm run format` — format via Prettier
- `npm run format:check` — CI-friendly format check
- Optional (if configured): `npm run lint:scripts`, `npm run lint:styles`

GitHub Actions runs quality checks under `.github/workflows/quality.yml`.

## Content Conventions

- Kebab-case slugs (e.g., `content/posts/outbound-flight/index.md`).
- ISO dates in front matter (`YYYY-MM-DD`).
- Prefer semantic classes mapping to PaperMod blocks in custom CSS.

## Deployment

Deployed via Vercel using `vercel.json`. Keep `HUGO_VERSION` aligned in deployment configuration. Configure DNS for `brettstark.com`.

## Notes

- Secrets belong in Vercel or GitHub Action secrets; do not commit secrets in `hugo.toml` or front matter.
- If you just cloned the repo, ensure the theme submodule is initialized (see Setup).
