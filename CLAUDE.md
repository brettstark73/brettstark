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

# GitHub Actions Workflow Policy

## ⚠️ CRITICAL: Do Not Create Additional Workflows

This project uses **qa-architect** with **minimal workflow mode** (~$0-5/mo).

### For AI Assistants (Claude, Copilot, etc.)

**❌ DO NOT:**
- Create new workflow files (`.github/workflows/*.yml`)
- Add jobs to existing `quality.yml`
- Suggest "comprehensive" CI improvements
- Add matrix builds or scheduled jobs

**✅ INSTEAD:**
- Use existing `quality.yml` (managed by qa-architect)
- Update via: `npx create-qa-architect@latest --update --workflow-minimal`
- Consult user before any CI changes

**Why:** Prevents $20-350/mo bloat. Current config: ~$0-5/mo with 60-90% CI savings.
