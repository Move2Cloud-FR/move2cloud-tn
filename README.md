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
├── amplify.yml             # AWS Amplify build config
├── _redirects              # SPA routing: /* → /index.html 200
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

## Deployment (GitHub Actions → AWS S3)

On every push to `main`, the workflow `.github/workflows/deploy.yml`:
1. Authenticates to AWS via **OIDC** (no long-lived credentials) using `GithubRunnerRole`
2. Syncs all site files to `s3://move2cloud.tn`
3. Sets short cache (`max-age=3600`) on HTML/JSON/XML and long cache (`max-age=31536000, immutable`) on assets
4. Optionally invalidates a CloudFront distribution if `CLOUDFRONT_DISTRIBUTION_ID` is set as a repository variable

**Required repository variables (GitHub → Settings → Variables):**

| Variable | Value |
|----------|-------|
| `AWS_ACCOUNT_ID` | Your AWS account ID |
| `CLOUDFRONT_DISTRIBUTION_ID` | *(optional)* CloudFront distribution ID |

**IAM role trust policy** — `GithubRunnerRole` must trust the GitHub OIDC provider:
```json
{
  "Effect": "Allow",
  "Principal": { "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com" },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
    "StringLike": { "token.actions.githubusercontent.com:sub": "repo:Move2Cloud-FR/move2cloud-tn:*" }
  }
}
```

## Deployment (AWS Amplify)

1. Push this repository to GitHub / CodeCommit
2. In the [Amplify Console](https://console.aws.amazon.com/amplify/), choose **Host web app** → connect the repo
3. Amplify auto-detects `amplify.yml` — no framework or build command needed
4. Connect your custom domain `move2cloud.tn` in **Domain management** (HTTPS included)
5. SPA routing is handled by `_redirects` (`/* → /index.html 200`), so `/about`, `/services`… all work on direct access

> **Note:** If you prefer to configure the redirect rule manually in the Amplify Console, go to  
> **App settings → Rewrites and redirects** → add `Source: </^[^.]+$|\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json)$)([^.]+$)/>`, Target: `/index.html`, Type: `200`.

## Contact

- **Address:** Espace Tunis, bloc H, bureau H3-1, Montplaisir 1073
- **Email:** contact@move2cloud.fr
- **RNE:** 1793146J

## Brand

- **Primary color:** `#c70039` (crimson)
- **Font:** Poppins (Google Fonts)
- **Logo:** Atomic network SVG icon
