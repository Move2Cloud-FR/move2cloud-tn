# Move2Cloud Tunisie — Static Website

Static single-page website for [move2cloud.tn](https://move2cloud.tn), a Cloud & DevOps consulting company based in Tunis, Tunisia.

## Stack

- Pure HTML/CSS with [Tailwind CSS](https://tailwindcss.com/) via CDN (no build step)
- [EmailJS](https://www.emailjs.com/) for contact form delivery
- External JSON files for i18n (FR / EN)
- Hosted on AWS S3 (static website hosting)

## Structure

```
move2cloud-tn/
├── index.html              # Single-page application
├── robots.txt
├── sitemap.xml
└── assets/
    ├── favicon.svg         # Brand icon (crimson #c70039)
    └── i18n/
        ├── fr.json         # French translations (default)
        └── en.json         # English translations
```

## Sections

| URL | Section |
|-----|---------|
| `/` | Hero |
| `/services` | Nos Services |
| `/about` | À propos |
| `/values` | Nos valeurs |
| `/approach` | Notre approche |
| `/contact` | Contactez-nous |

Navigation uses the History API — clicking a link updates the URL to `/about`, `/services`… without a page reload. S3 must serve `index.html` as the error document for direct URL access to work.

## i18n

All translatable strings are stored in `assets/i18n/{lang}.json` and loaded via `fetch()` on language selection. The selected language is persisted in `localStorage`.

To add a new language:
1. Create `assets/i18n/{code}.json` with the same 109 keys as `fr.json`
2. Add an `<option>` to the language switcher in `index.html`
3. Add a case in the `setLang` function

## Deployment (AWS S3)

1. Create an S3 bucket named `move2cloud.tn`
2. Enable **Static website hosting** (index document: `index.html`, error document: `index.html`)
3. Set bucket policy to allow public read access
4. Upload all files maintaining the directory structure
5. (Optional) Configure CloudFront for HTTPS and custom domain

## Contact

- **Address:** Espace Tunis, bloc H, bureau H3-1, Montplaisir 1073
- **Email:** contact@move2cloud.fr
- **RNE:** 1793146J

## Brand

- **Primary color:** `#c70039` (crimson)
- **Font:** Poppins (Google Fonts)
- **Logo:** Atomic network SVG icon
