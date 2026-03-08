# Dev Guide — brettstark.com

> Load this at session start. Replaces blind codebase exploration.
> Update when patterns change.

**Last updated:** 2026-03-08

---

## What This Project Does

Personal Hugo blog deployed on Vercel at brettstark.com, covering Technology, Space, Travel, and Photography. Content is authored in Markdown as Hugo page bundles; theme styling is extended via layout overrides and custom CSS.

**Tech stack:** Hugo 0.150.0 (extended), PaperMod theme (Git submodule), Node.js 20+ tooling (ESLint 9, Prettier, Stylelint, Vitest, Lighthouse CI), Vercel hosting
**Entry point:** `hugo server -D` or `npm run dev`

---

## Directory Structure

```
brettstark/
├── content/posts/        # Blog posts as Hugo page bundles
├── archetypes/           # Default front matter for new content
├── layouts/              # Layout overrides extending PaperMod theme
├── assets/css/extended/  # Custom CSS (extends theme styles)
├── static/               # Passthrough files: favicons, large media
├── themes/hugo-papermod/ # Theme as Git submodule (do not edit directly)
├── scripts/              # Bash helpers: image optimization, SEO, smart test
├── tests/                # Vitest test suite
├── public/               # Build output (generated, do not commit)
└── resources/            # Hugo resource cache (generated)
```

---

## Key Files

| File                   | Role                                                  |
| ---------------------- | ----------------------------------------------------- |
| `hugo.toml`            | Hugo site config: baseURL, title, params, menu, theme |
| `package.json`         | npm scripts, devDependencies, lint-staged config      |
| `eslint.config.cjs`    | ESLint 9 flat config for JS/HTML                      |
| `.prettierrc`          | Prettier formatting rules                             |
| `.stylelintrc.json`    | Stylelint rules for CSS/SCSS                          |
| `commitlint.config.js` | Conventional commit enforcement                       |
| `.lighthouserc.js`     | Lighthouse CI thresholds                              |
| `vercel.json`          | Vercel deployment config                              |
| `.gitleaks.toml`       | Secret scanning rules                                 |
| `setup.js`             | One-time project setup script                         |

---

## Conventions

### Naming

- **Files/slugs:** kebab-case (e.g., `content/posts/outbound-flight/index.md`)
- **CSS classes:** semantic classes mapping to PaperMod blocks (e.g., `.post-header`, `.entry-content`)
- **Tags:** lowercase, descriptive (e.g., `technology`, `space`, `travel`)

### Adding a New Post

1. Create page bundle: `hugo new posts/my-post-name/index.md`
2. Add images to `content/posts/my-post-name/images/`
3. Set front matter: `title`, `date` (ISO `YYYY-MM-DD`), `tags`, `description`, `cover`
4. Set `draft: false` when ready to publish
5. Run `npm run dev` and verify locally before committing

### Adding a Layout Override

1. Copy the target template from `themes/hugo-papermod/layouts/` into `layouts/`
2. Edit the copy — never edit theme files directly
3. Verify with `npm run dev`

### Adding Custom CSS

1. Edit files under `assets/css/extended/` (not theme CSS)
2. Use semantic class names that map to PaperMod block structure

---

## Running the Project

```bash
# Install (first time)
git submodule update --init --recursive
npm install

# Run dev server
npm run dev          # hugo server -D with drafts + live reload
npm run dev:full     # full rebuild, fast render off

# Build for production
npm run build        # hugo --gc --minify → output in public/

# Tests
npm test             # placeholder (add vitest suite)
npm run test:fast    # vitest run without coverage
npm run test:coverage # vitest with V8 coverage

# Lint / format / type-check
npm run lint         # ESLint + Stylelint
npm run lint:fix     # ESLint + Stylelint with auto-fix
npm run format       # Prettier write
npm run format:check # Prettier check (CI)
npm run quality:check # type-check + lint + test

# Other
npm run images:optimize   # optimize images via scripts/
npm run lighthouse:ci     # Lighthouse CI audit
npm run security:audit    # npm audit (high severity)
npm run security:secrets  # scan for hardcoded secrets
```

---

## Agent Gotchas

- **Never edit theme directly:** All theme customizations go in `layouts/` (overrides) or `assets/css/extended/` (styles). Edits to `themes/hugo-papermod/` are lost on submodule updates.
- **Submodule init required:** After cloning, run `git submodule update --init --recursive` or the site won't build.
- **Git LFS required:** Large media files use LFS — run `git lfs install` before committing images.
- **Hugo extended required:** The extended variant is needed for SCSS processing. Plain Hugo will fail.
- **public/ and resources/ are generated:** Never commit these; they're in `.gitignore`.
- **No new GitHub Actions workflows:** Per `.claude-setup/docs/GITHUB-ACTIONS-POLICY.md`, minimal workflow mode is in effect — do not add new workflows.
- **Conventional commits enforced:** commitlint runs via Husky; use `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`.

Required env vars: Secrets live in Vercel and GitHub Actions secrets. See `SECURITY.md`. Do not add secrets to `hugo.toml` or front matter.

---

## Active Development Areas

Recent commits show focus on quality automation (qa-architect upgrades, gitleaks config tuning, Dependabot optimization) and CI/CD maintenance. Content authoring and layout customization are the primary ongoing work areas.
