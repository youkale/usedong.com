# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal Hugo static blog (usedong.com) with a custom terminal-themed design. Content is primarily in Chinese with some English posts. Deployed to Cloudflare Pages via GitHub Actions on pushes to `master`.

## Commands

```bash
make dev          # Start local dev server at http://localhost:1313 (includes drafts)
make build        # Build for production → public/
make test         # Build, print stats, then clean up
make clean        # Remove public/ and resources/
make deploy-cf    # Build + deploy to Cloudflare Pages (requires wrangler CLI)
make preview      # Build + serve locally via python3 on port 8080

# Create new content
hugo new posts/my-post.md
hugo new projects/my-project.md
hugo new tools/my-tool.md
hugo new translations/series-name/my-article.md
```

## Architecture

The site uses Hugo's built-in templating with **no external theme** — everything lives in `layouts/` and `static/`.

**Template structure:**
- `layouts/_default/baseof.html` — shell: calls `head`, `header`, `main` block, `footer` partials
- `layouts/_default/single.html` — individual post/page rendering
- `layouts/_default/list.html` — section list pages (posts, tools, translations, etc.)
- `layouts/index.html` — homepage (shows last 3 posts + 3 projects)
- `layouts/partials/` — `head.html`, `header.html`, `footer.html`
- `layouts/shortcodes/` — `link.html` and `linkcard.html` for rich link embeds in content
- `layouts/index.llmstxt` — generates `/llms.txt` for LLM discoverability (custom output format)

**Content sections** (`content/`):
- `posts/` — blog articles
- `projects/` — project showcases
- `tools/` — developer tool write-ups
- `translations/` — translated articles (currently agent design pattern series)

**Styling:** Single file `static/css/style.css` (~30KB). CSS custom properties for the color scheme are defined at `:root` — `--bg-primary: #0a1e1e`, `--accent-green: #4ade80`, etc.

**Custom output format:** `hugo.toml` defines `llmstxt` output on the homepage which generates `public/llms.txt` via `layouts/index.llmstxt`.

## Content Front Matter

Posts support: `title`, `date`, `draft`, `tags`, `categories`, `image` (path under `/images/`).

Images go in `static/images/` and are referenced as `/images/filename.jpg`.

## Deployment

- **Auto-deploy**: Push to `master` → GitHub Actions builds with Hugo Extended → deploys to Cloudflare Pages project `usedong`
- Requires secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`
- **Manual deploy**: `make deploy-cf` (requires `wrangler` CLI installed globally)
