# brettstark.com - Claude Guide

> Personal Hugo blog covering Technology, Space, Travel, and Photography.

**Domain**: brettstark.com | **Hugo**: 0.150.0 | **Theme**: PaperMod

## Tech Stack

| Layer     | Technology                      |
| --------- | ------------------------------- |
| Generator | Hugo 0.150.0 (extended)         |
| Theme     | PaperMod (Git submodule)        |
| Hosting   | Vercel                          |
| Quality   | ESLint 9 + Prettier + Stylelint |

## Key Commands

```bash
npm run dev              # Hugo server with drafts
npm run build            # Production build
npm run lint             # ESLint + Stylelint
npm run format           # Prettier
npm run images:optimize  # Optimize images
npm run quality:check    # Full quality check
```

## Project Structure

```
brettstark/
├── content/posts/       # Blog posts (page bundles)
│   └── [post-name]/
│       ├── index.md    # Post content
│       └── images/     # Post images
├── assets/css/extended/ # Custom CSS
├── layouts/             # Layout overrides
├── static/              # Static assets
└── themes/hugo-papermod/ # Theme (submodule)
```

## Content Structure

### Page Bundle

```
content/posts/my-post/
├── index.md           # Post content
└── images/
    └── cover.jpg
```

### Front Matter

```yaml
---
title: 'Post Title'
date: 2024-01-15
draft: false
tags: ['technology', 'space']
description: 'SEO description'
cover:
  image: 'images/cover.jpg'
  alt: 'Cover description'
---
```

## Common Tasks

### New Post

```bash
hugo new posts/my-new-post/index.md
# Add images to content/posts/my-new-post/images/
# Set draft: false when ready
```

### Update Theme

```bash
cd themes/hugo-papermod && git pull origin master && cd ../..
git add themes/hugo-papermod && git commit -m "chore: update theme"
```

## What NOT to Do

- Don't edit theme files directly (use `layouts/` overrides)
- Don't commit to `themes/hugo-papermod/` (submodule)
- Don't use `--no-verify` on commits
- Don't add large files without Git LFS

---

_See README for setup. Global rules in `~/.claude/CLAUDE.md`._

---

## GitHub Actions Policy

See `.claude-setup/docs/GITHUB-ACTIONS-POLICY.md` — minimal workflow mode, no new workflows.

## Pre-Action Checklist

Before suggesting ANY infrastructure, CI/CD, or tooling changes:

1. Run `ls .github/workflows/` to see existing workflows
2. Run `cat package.json | grep scripts -A 50` to see available commands
3. Check for `.qualityrc.json`, `CLAUDE.md`, or similar config files

## Quality Automation (create-qa-architect)

This project uses `create-qa-architect` for CI/CD quality gates. Before suggesting or creating ANY new GitHub Actions workflows for lint/test/security/formatting, you MUST first check:

1. `.github/workflows/quality.yml` — already exists and handles all quality checks
2. `.qualityrc.json` — CQA configuration file

**DO NOT** create duplicate workflows. The existing workflow handles ESLint, Prettier, Stylelint, test execution, npm audit, and secret detection.

Available commands (use these instead of suggesting new workflows):

```bash
npm run quality:ci       # Full CI quality pipeline
npm run validate:all     # Comprehensive validation
npm run lint             # ESLint + Stylelint
npm run lint:fix         # Auto-fix
npm run format:check     # Check formatting
npm run format           # Fix formatting
npm run security:audit   # Dependency security check
```

## Tooling & Deployment Notes

- Install `git-lfs` locally; Husky hooks enforce this on `post-merge` and `pre-push`
- Vercel deploys via `vercel.json`; update DNS for `brettstark.com` and keep `HUGO_VERSION` aligned
- Node 20+ required; Volta and `.nvmrc` pin versions — run `npm install` after checkout
- Secrets belong in Vercel or GitHub Action secrets — never in `hugo.toml` or content front matter
- `npm run dev:full` disables fast render for full rebuilds when needed

---

**Last Updated:** 2026-03-08

---

## Agent Workflow

### Session Start

Load codebase context before exploring:

```
Read docs/dev_guide/CONVENTIONS.md
```

### Planning Complex Work

Before implementing anything spanning multiple files:

```
/bs:plan <feature-name>
```

Plans live in docs/plans/ and survive context resets.

### Session Handoff

```
/bs:context --save   # before ending session or running /compact
/bs:context --resume # at start of new session
```
