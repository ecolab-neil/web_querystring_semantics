# Deploy to GitHub Pages

Simple instructions to deploy your Flutter web app to GitHub Pages.

## Prerequisites

- Flutter SDK installed
- Git repository on GitHub
- GitHub account

## Quick Deploy Steps

### 1. Build for Web

```bash
flutter build web --release
```

This creates optimized web files in the `build/web/` directory.

### 2. Prepare for GitHub Pages

GitHub Pages serves files from the `docs/` folder or a `gh-pages` branch. We'll use the `docs/` folder method:

```bash
# Create docs directory
mkdir docs

# Copy built files to docs
cp -r build/web/* docs/

# Add docs to git
git add docs/
git commit -m "Add web build for GitHub Pages"
git push origin main
```

### 3. Enable GitHub Pages

1. Go to your GitHub repository
2. Click **Settings** tab
3. Scroll down to **Pages** section
4. Under **Source**, select **Deploy from a branch**
5. Choose **main** branch and **/docs** folder
6. Click **Save**

### 4. Access Your App

Your app will be available at:
```
https://yourusername.github.io/web_querystring_semantics/
```

## Testing Your Deployment

Once deployed, test these URLs:

- `https://yourusername.github.io/web_querystring_semantics/`
- `https://yourusername.github.io/web_querystring_semantics/?enableSemantics=true`
- `https://yourusername.github.io/web_querystring_semantics/?enableSemantics=false`
- `https://yourusername.github.io/web_querystring_semantics/?enableSemantics=True`

## Automated Deployment (Optional)

For automatic deployment on every push, create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.9.2'
        
    - run: flutter pub get
    - run: flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

Then change GitHub Pages source to **Deploy from a branch** → **gh-pages**.

## Troubleshooting

- **404 Error**: Make sure GitHub Pages is enabled and pointing to `/docs` folder
- **Build Issues**: Run `flutter clean` then `flutter build web --release`
- **Caching**: GitHub Pages may take a few minutes to update after pushing changes

## Manual Update Process

When you make changes to your app:

```bash
# Build new version
flutter build web --release

# Copy to docs
cp -r build/web/* docs/

# Commit and push
git add docs/
git commit -m "Update web build"
git push origin main
```

That's it! Your Flutter web app is now live on GitHub Pages.
