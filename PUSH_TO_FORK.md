# Push RHEL 9.6 branch to your fork

The branch **`rhel9.6-support`** and tag **`rhel9.6-v1`** are ready. Push failed from here (no GitHub auth / fork may not exist). Do this **in your own terminal** so you can sign in:

## 1. Create the fork (if you haven’t)

1. Open https://github.com/Azure/azhpc-images  
2. Click **Fork** → create the fork under your account.

## 2. Point `fork` at your repo

Replace **ariel-adam** with your GitHub username:

```bash
cd "/Users/aadam/RHEL HPC/azhpc-images"

# If you already have a remote named "fork" and need to fix the URL:
git remote set-url fork git@github.com:ariel-adam/azhpc-images.git

# If you don’t have "fork" yet:
# git remote add fork git@github.com:ariel-adam/azhpc-images.git
```

(Use HTTPS if you prefer: `https://github.com/ariel-adam/azhpc-images.git`)

## 3. Push branch and tag

```bash
git push fork rhel9.6-support
git push fork rhel9.6-v1
```

If you use HTTPS, Git may ask for username and a **Personal Access Token** (not your password).

Done. Others can clone your fork and run: `git checkout rhel9.6-support`
