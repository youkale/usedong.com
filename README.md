# YKL Blog - Terminal Theme

A terminal-themed Hugo blog with a modern, responsive design.

## Features

- ✅ **Responsive Design**: Works seamlessly on desktop and mobile devices
- ✅ **Terminal Theme**: Unique retro-inspired terminal aesthetic
- ✅ **Modular Structure**: Reusable header and footer partials
- ✅ **Multiple Sections**: Home, Posts, Projects, Favorites, Translation, About
- ✅ **Social Integration**: Configurable GitHub, Twitter, Instagram links
- ✅ **Analytics Support**: Google Analytics and Adsense ready
- ✅ **SEO Optimized**: Meta tags and Open Graph support
- ✅ **Fast Performance**: Hugo's lightning-fast static site generation

## Quick Start

### Prerequisites

- Hugo Extended (v0.80.0 or later)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd ykl-blog
```

2. Run the development server:
```bash
hugo server -D
```

3. Visit `http://localhost:1313` to see your site

## Configuration

Edit `hugo.toml` to customize your blog:

```toml
[params]
  author = "Your Name"
  description = "Your blog description"
  avatar = "/images/avatar.jpg"

  [params.social]
    github = "https://github.com/yourusername"
    twitter = "https://twitter.com/yourusername"
    instagram = "https://instagram.com/yourusername"

  googleAnalytics = "G-XXXXXXXXXX"
  googleAdsense = "ca-pub-XXXXXXXXXXXXXXXX"
```

## Content Structure

```
content/
├── _index.md           # Homepage
├── about.md            # About page
├── contact.md          # Contact page
├── posts/              # Blog posts
│   ├── _index.md
│   └── post-1.md
├── projects/           # Project showcase
│   ├── _index.md
│   └── project-1.md
├── favorites/          # Favorite resources
│   └── _index.md
└── translation/        # Translated articles
    └── _index.md
```

## Creating Content

### New Post

```bash
hugo new posts/my-new-post.md
```

### New Project

```bash
hugo new projects/my-project.md
```

### Front Matter Example

```yaml
---
title: "My Post Title"
date: 2024-01-01
tags: ["tag1", "tag2"]
categories: ["category"]
image: "/images/posts/featured.jpg"
---
```

## Customization

### Colors

Edit CSS variables in `static/css/style.css`:

```css
:root {
  --bg-primary: #0a1e1e;
  --accent-green: #4ade80;
  /* ... more colors */
}
```

### Menu

Add menu items in `hugo.toml`:

```toml
[[menu.main]]
  identifier = "newpage"
  name = "New Page"
  url = "/newpage"
  weight = 5
```

## Building for Production

```bash
hugo --minify
```

The site will be generated in the `public/` directory.

## Deployment

### Netlify

1. Connect your repository to Netlify
2. Build command: `hugo --minify`
3. Publish directory: `public`

### Vercel

1. Import your repository
2. Framework preset: Hugo
3. Deploy

### GitHub Pages

```bash
hugo --minify
# Push the public directory to gh-pages branch
```

## Adding Images

Place images in `static/images/`:

```
static/
└── images/
    ├── avatar.jpg
    ├── posts/
    │   └── post-image.jpg
    └── projects/
        └── project-image.jpg
```

Reference in content:

```markdown
![Alt text](/images/posts/post-image.jpg)
```

## License

MIT License - feel free to use this theme for your own blog!

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

## Credits

Built with [Hugo](https://gohugo.io/) - The world's fastest framework for building websites.
