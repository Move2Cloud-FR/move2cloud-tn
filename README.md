# Move2Cloud Tunisie — Static Website

Static multi-page website for [move2cloud.tn](https://move2cloud.tn), a Cloud & DevOps consulting company based in Tunis, Tunisia.

## Stack

- Pure HTML with [Tailwind CSS](https://tailwindcss.com/) via CDN (no build step)
- [EmailJS](https://www.emailjs.com/) for contact and job application form delivery
- Bilingual (FR / EN): JSON dictionaries + inline `data-i18n` / `data-en` attributes
- Hosted on AWS S3 (static website hosting)

## Structure

```
move2cloud-tn/
├── index.html                  # Home page (SPA — sections: Services, À propos, Valeurs, Approche, Contact)
├── rejoindre.html              # Job listings (51 offers, filterable by city and domain)
├── actualites.html             # News / blog
├── robots.txt
├── sitemap.xml
├── assets/
│   ├── favicon.svg             # Brand icon (crimson #c70039)
│   └── i18n/
│       ├── fr.json             # French translations (default)
│       └── en.json             # English translations
└── nous-rejoindre/             # 51 individual job offer pages
    ├── chef-de-projet-it-montpellier.html
    ├── developpeur-java-h-f-montpellier.html
    ├── assistante-de-direction.html
    └── …
```

## Pages

| File | Description |
|------|-------------|
| `index.html` | Home — Services, À propos, Valeurs, Approche, Actualités, Contact |
| `rejoindre.html` | All 51 job offers in a 3-column grid with city + domain filters |
| `actualites.html` | News articles |
| `nous-rejoindre/*.html` | One page per job offer with missions, profile, benefits, and application form |

`index.html` uses the History API for in-page navigation (`/services`, `/about`…) — S3 must serve `index.html` as the error document for direct URL access to work.

## i18n

The site supports French (default) and English. Two complementary mechanisms are used:

**1. JSON dictionary** (`assets/i18n/{lang}.json`) — for shared UI strings:
```html
<span data-i18n="job.sec1">À propos du poste</span>
```
Keys are fetched and applied at language switch via `loadLang()`.

**2. Inline attributes** — for per-page content:
```html
<h1 data-en="IT Project Manager">Chef de Projet IT</h1>
<p data-en="Join our team…">Rejoignez notre équipe…</p>
```
Applied by `applyInlineTranslations(lang)` at language switch.

Form placeholders use `data-en-placeholder` / `data-fr-placeholder`. The selected language is persisted in `localStorage`.

## Job Offers

The 51 job offer pages follow a consistent structure:
- Dark hero header with job title, location, contract type, and availability badges
- Sections: À propos du poste · Vos missions · Profil requis · Ce que nous offrons · Compétences clés
- Sidebar with job details card
- EmailJS application form (CV upload via Base64)
- Fully bilingual (FR/EN)

**EmailJS credentials** (stored inline in each page):
- Service ID: `service_rqwhxgi`
- Template ID: `template_3cwgv1p`
- Public Key: `vUJW1aDvhHR4GjOX8`

## Deployment (GitHub Actions → AWS S3)

On every push to `main`, the workflow `.github/workflows/deploy.yml`:
1. Authenticates to AWS via **OIDC** (no long-lived credentials) using `GithubRunnerRole`
2. Syncs all site files to the S3 bucket
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

## Contact

- **Address:** Espace Tunis, bloc H, bureau H3-1, Montplaisir 1073
- **Email:** contact@move2cloud.fr
- **RNE:** 1793146J

## Brand

- **Primary color:** `#c70039` (crimson)
- **Font:** Poppins (Google Fonts)
- **Logo:** Atomic network SVG icon
