# 🌐 Web Deployment Guide

This guide will help you deploy your Pet Adoption App to various free hosting platforms.

## 🚀 Quick Deployment Options

### 1. GitHub Pages (Recommended - Free & Easy)

#### Step 1: Push your code to GitHub
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

#### Step 2: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Scroll down to **Pages** section
4. Under **Source**, select **GitHub Actions**
5. The deployment will happen automatically via the `.github/workflows/deploy.yml` file

#### Step 3: Access your app
Your app will be available at: `https://yourusername.github.io/Pet_adoption_app/`

### 2. Netlify Deployment

#### Option A: Drag & Drop (Quick)
1. Build your app locally:
   ```bash
   flutter build web --release
   ```
2. Go to [Netlify](https://netlify.com)
3. Drag the `build/web` folder to the deployment area
4. Your site will be live instantly!

#### Option B: Git Integration (Automatic deployments)
1. Go to [Netlify](https://netlify.com) and sign up
2. Click "New site from Git"
3. Connect your GitHub repository
4. Set build command: `flutter build web --release`
5. Set publish directory: `build/web`
6. Click "Deploy site"

### 3. Vercel Deployment

#### Step 1: Install Vercel CLI
```bash
npm i -g vercel
```

#### Step 2: Deploy
```bash
# Build the app
flutter build web --release

# Deploy to Vercel
cd build/web
vercel --prod
```

#### Step 3: Custom Domain (Optional)
- Add your custom domain in Vercel dashboard
- Update DNS settings as instructed

### 4. Firebase Hosting

#### Step 1: Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

#### Step 2: Initialize Firebase
```bash
firebase init hosting
# Choose build/web as the public directory
# Configure as single-page app: Yes
# Overwrite index.html: No
```

#### Step 3: Deploy
```bash
flutter build web --release
firebase deploy
```

## 🔧 Build Optimization

### For Production Builds
```bash
# Build with optimizations
flutter build web --release --web-renderer html

# With custom base href (for GitHub Pages)
flutter build web --release --web-renderer html --base-href "/your-repo-name/"

# With specific target platform
flutter build web --release --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.34.0/bin/
```

### Environment Variables
Create different API keys for production:

```dart
// lib/core/api/api_keys.dart (for production)
const String theCatApiKey = String.fromEnvironment('CAT_API_KEY', defaultValue: 'demo_key');
const String theDogApiKey = String.fromEnvironment('DOG_API_KEY', defaultValue: 'demo_key');
```

## 📱 PWA Features

Your app is already configured as a Progressive Web App (PWA) with:
- ✅ Web manifest
- ✅ Service worker
- ✅ Offline support
- ✅ Install prompt

## 🔍 SEO Optimization

The web build includes:
- ✅ Proper meta tags
- ✅ Structured data
- ✅ Mobile-friendly design
- ✅ Fast loading times

## 🚨 Important Notes

### Security
- **Never commit real API keys** to version control
- Use environment variables for production
- Enable HTTPS on your hosting platform

### Performance
- Web builds are larger than mobile apps
- Consider lazy loading for better performance
- Use `--web-renderer html` for better compatibility

### CORS Issues
If you encounter CORS issues with the pet APIs:
1. Use a CORS proxy service
2. Implement server-side API calls
3. Contact the API provider for whitelist

## 📊 Monitoring & Analytics

### Add Google Analytics (Optional)
Add to your `web/index.html`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_TRACKING_ID');
</script>
```

## 🆘 Troubleshooting

### Common Issues

1. **White screen on load**
   - Check browser console for errors
   - Ensure all assets are loading correctly
   - Verify base href configuration

2. **API calls failing**
   - Check CORS configuration
   - Verify API keys are properly set
   - Test API endpoints directly

3. **Large bundle size**
   - Use `--split-debug-info` flag
   - Enable tree shaking
   - Optimize images and assets

### Performance Tips
- Use `flutter build web --release` for production
- Optimize images in the `web/` folder
- Enable gzip compression on your hosting platform
- Use a CDN for faster global delivery

## 🎉 Success!

Once deployed, your Pet Adoption App will be accessible worldwide! Share the link with users and start helping pets find their forever homes! 🐱🐶

### Example URLs after deployment:
- **GitHub Pages**: `https://shubham-gupta0.github.io/Pet_adoption_app/`
- **Netlify**: `https://your-site-name.netlify.app`
- **Vercel**: `https://your-project.vercel.app`
- **Firebase**: `https://your-project.web.app`
