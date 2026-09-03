# Build React app
cd frontend
npm run build
cd ..

# Sync to S3
aws s3 sync frontend/build/ s3://forge-rpg-portfolio-bucket --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"