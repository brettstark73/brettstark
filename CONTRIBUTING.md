# Contributing

Thanks for helping improve this site. A few guidelines keep things consistent and easy to review.

## Commit Messages

- Use `Type: summary` format, capped at 72 characters.
- Examples: `Content: import 2020 recap`, `Fix: adjust header tagline`.
- Group related edits per commit and document notable migrations or media handling in the body.

## Pull Requests

- Describe the change and its motivation.
- Note any new large assets or LFS requirements.
- Include screenshots for visual tweaks.
- Link tracking issues if applicable.
- Ensure CI is green before requesting review.

## Local Quality Checks

- `npm run format` — format via Prettier.
- `npm run format:check` — CI-friendly format check.
- `npm run lint` — ESLint + Stylelint check.

## Development & Build

- Dev server: `npm run dev` (or `hugo server -D` if scripts aren’t present).
- Full rebuilds: `npm run dev:full`.
- Production build: `npm run build` (or `hugo --gc --minify`).

## Content & Styling Conventions

- Content bundles under `content/…/index.md` with images in a sibling `images/` folder.
- Slugs are kebab-case; front matter dates use ISO `YYYY-MM-DD`.
- CSS in `assets/` follows `stylelint-config-standard`; prefer semantic class names aligned to PaperMod blocks.

## Tooling Notes

- Node.js 20+ required. Use Volta/`.nvmrc` as needed.
- Git LFS must be installed locally; Husky hooks enforce LFS on `post-merge` and `pre-push`.
- Secrets belong in Vercel or GitHub Action secrets—never commit secrets to `hugo.toml` or content.
