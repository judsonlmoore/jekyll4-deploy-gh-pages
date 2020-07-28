#!/bin/bash

set -e

DEST="${JEKYLL_DESTINATION:-_site}"
REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
BRANCH="gh-pages"
BUNDLE_BUILD__SASSC=--disable-march-tune-native

echo "Installing gems..."

# bundle config path vendor/bundle
bundle install --jobs 4 --retry 3

echo "Building Jekyll site..."

bundle exec jekyll build --trace

echo "Publishing..."

cd ${DEST}

git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "published by GitHub Actions"
git push --force ${REPO} master:${BRANCH}

echo "Indexing search"

ALGOLIA_API_KEY='${{ secrets.ALGOLIA_API_KEY }}' bundle exec jekyll algolia
