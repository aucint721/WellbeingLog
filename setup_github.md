# GitHub Repository Setup Guide

## Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the "+" icon in the top right corner
3. Select "New repository"
4. Name the repository: `Wellbeing-Log`
5. Make it **Public** (required for GitHub Pages)
6. **Do NOT** initialize with README, .gitignore, or license (we already have these)
7. Click "Create repository"

## Step 2: Connect Local Repository to GitHub

After creating the repository, GitHub will show you commands. Run these in your terminal:

```bash
git remote add origin https://github.com/hendrikaucamp/Wellbeing-Log.git
git branch -M main
git push -u origin main
```

## Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click "Settings" tab
3. Scroll down to "Pages" in the left sidebar
4. Under "Source", select "Deploy from a branch"
5. Choose "gh-pages" branch (will be created by GitHub Actions)
6. Click "Save"

## Step 4: Verify Setup

After pushing your code, the GitHub Actions workflow will automatically:
- Build and deploy your support website
- Create the `gh-pages` branch
- Make your website available at: `https://hendrikaucamp.github.io/Wellbeing-Log/`

## Step 5: Update App Store Submission

Once the website is live, update your App Store submission with:
- **Support URL**: `https://hendrikaucamp.github.io/Wellbeing-Log/`
- **Marketing URL**: `https://hendrikaucamp.github.io/Wellbeing-Log/`

## Files Added to Repository

- `index.html` - Main support website
- `support.html` - Original support page
- `README.md` - Repository documentation
- `.gitignore` - Excludes build artifacts
- `.github/workflows/deploy.yml` - GitHub Actions deployment
- App Store submission documentation

## Next Steps

1. Push your code to GitHub
2. Enable GitHub Pages in repository settings
3. Wait for the website to deploy (usually 2-5 minutes)
4. Test the website at the provided URL
5. Update your App Store submission with the support URL 