# website-portfolio

One-page CV site of Maksim Kirillov, at <https://oliverolsson.xyz>. Static HTML and CSS on Firebase Hosting, with infrastructure in Terraform and deployment through GitHub Actions without keys.

## How it fits together

- `site/` is the page. All text lives in `site/index.html`.
- `scripts/build.mjs` copies `site/` to `dist/` and fills in the phone number, the PDF and the analytics code.
- `terraform/bootstrap` holds the APIs and the state bucket, and `terraform/envs/prod` holds everything else, built from `terraform/modules`.
- `.github/workflows/deploy.yml` builds and deploys on every push to `main` that touches the site.

The phone number and the PDF are not in git. The number is in Secret Manager (`resume-phone`) and the PDF is in a private bucket, and only the CI service account can read them. This keeps them out of the repository. They are still public on the site itself.

## Update content

Text, skills or styles: edit `site/`, then commit and push to `main`. Preview it first:

```bash
node scripts/build.mjs
```

```bash
python3 -m http.server 8080 --directory dist
```

A local build shows a placeholder instead of the phone number, and uses `Maksim_Kirillov_CV_terminal.pdf` from the project root if it is there.

New PDF:

```bash
gcloud storage cp NEW_FILE.pdf gs://resume-website-513516-private/cv.pdf
```

New phone number, in the form it should appear on the site:

```bash
printf '%s' '+00 000 000 000' | gcloud secrets versions add resume-phone --data-file=- --project resume-website-513516
```

After changing the PDF or the number, deploy by hand:

```bash
gh workflow run deploy.yml --repo oliverxyz/website-portfolio
```

## Change infrastructure

Terraform runs by hand, never in CI. Sign in with `gcloud auth application-default login`, and copy `terraform.tfvars.example` to `terraform.tfvars` with the billing account ID.

```bash
terraform -chdir=terraform/envs/prod init
```

```bash
terraform -chdir=terraform/envs/prod plan -out=tfplan
```

```bash
terraform -chdir=terraform/envs/prod apply tfplan
```

## DNS

Managed by hand in Cloudflare, with the proxy off (DNS only):

| Type | Name | Value |
| --- | --- | --- |
| A | `@` | `199.36.158.100` |
| TXT | `@` | `hosting-site=resume-website-513516` |
| CNAME | `www` | `resume-website-513516.web.app` |

The existing SPF record on `@` belongs to Cloudflare email and stays.

## Cost

About 0 EUR a month at low traffic. No resource here has a fixed monthly fee.

| Item | Cost |
| --- | --- |
| Firebase Hosting | Free up to 10 GB stored and 360 MB transferred a day, then $0.026/GB stored and $0.15/GB transferred |
| Secret Manager | One secret version, inside the free 6 versions and 10,000 accesses a month |
| Two storage buckets | Close to nothing, they hold a few small files |
| Budget, IAM, Workload Identity | No charge expected |
| Domain | Paid separately at the registrar |

A budget alert emails the billing admins at 50%, 90% and 100% of 30 EUR. It does not stop spending.

Analytics use the free hosted GoatCounter, which works without cookies. The code is in the `GOATCOUNTER_CODE` repository variable.

## Remove everything

1. Remove the three DNS records above in Cloudflare.
2. Empty the private bucket, because Terraform will not delete a bucket with files in it:

   ```bash
   gcloud storage rm gs://resume-website-513516-private/cv.pdf
   ```

3. Remove the site and everything created for it. Read the plan it prints before you confirm:

   ```bash
   terraform -chdir=terraform/envs/prod destroy
   ```

4. The state bucket and the APIs stay, because `terraform/bootstrap` manages them separately and the bucket has `force_destroy = false`. To remove the whole project with them:

   ```bash
   gcloud projects delete resume-website-513516
   ```

These removal steps have not been run.
