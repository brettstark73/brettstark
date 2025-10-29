# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is Brett Stark's personal Hugo-based website built with the PaperMod theme. The site includes a blog with photo galleries, an about page, and contact information. It's deployed on Vercel with Git LFS for managing large image files.

## Architecture & Structure

- **Hugo Static Site Generator**: Uses Hugo v0.150.0 with the hugo-papermod theme
- **Content Organization**: Rich content bundles in `content/posts/` with images stored in sibling `images/` folders
- **Theme**: Uses vendored `themes/hugo-papermod/` theme with custom overrides in `layouts/`
- **Assets**: Custom CSS in `assets/css/extended/` for Hugo Pipes processing
- **Static Files**: Favicons and passthrough files in `static/`
- **Build Output**: Generated site in `public/`, Hugo resources cache in `resources/`

## Development Commands

### Setup

```bash
npm install  # Install Node.js dependencies (requires Node 20+)
```

### Development

```bash
hugo server -D        # Start dev server with drafts
npm run dev          # Alias for hugo server -D with live reload
npm run dev:full     # Disable fast render for full rebuilds
```

### Building

```bash
hugo --gc --minify   # Build production site
npm run build        # Alias for hugo build command
```

### Quality & Formatting

```bash
npm run format       # Format all files with Prettier
npm run format:check # Check formatting (used in CI)
npm run lint:scripts # ESLint for JavaScript/TypeScript
npm run lint:styles  # Stylelint for CSS
npm run prepare      # Set up Husky git hooks
```

## Content Management

### Creating New Posts

- Posts go in `content/posts/[slug]/index.md`
- Images stored in `content/posts/[slug]/images/`
- Use kebab-case slugs and ISO date format (YYYY-MM-DD)
- Front matter should include title, date, description

### Large Media Files

- Uses Git LFS for large images and videos
- Install git-lfs locally before working with media
- Husky hooks enforce LFS on post-merge and pre-push

## Deployment

### Vercel Configuration

- Deploys via `vercel.json` with Hugo v0.150.0
- Build command: `hugo`
- Output directory: `public`
- Custom domain: brettstark.com

### URL Management

When deploying to custom domains, verify:

- Canonical URLs in HTML meta tags
- Open Graph URLs
- JSON-LD schema URLs
- Use `vercel domains inspect [domain]` to check domain assignment

## Code Style

- **Prettier**: 2-space indentation, single quotes, 80-character line length
- **ESLint**: Standard recommended rules for JavaScript/TypeScript in `assets/`
- **CSS**: Follows stylelint-config-standard, semantic class names
- **Commits**: Format as "Type: summary" (max 72 chars)

## Quality Automation

- **GitHub Actions**: Runs quality checks on push/PR via `.github/workflows/quality.yml`
- **Pre-commit Hooks**: Prettier formatting via Husky
- **lint-staged**: Only processes changed files for performance

## Important Notes

- Never commit secrets to hugo.toml or content front matter
- Keep HUGO_VERSION in vercel.json aligned with local Hugo version
- Theme customizations go in `layouts/` to override theme defaults
- Git LFS is required for working with media files
