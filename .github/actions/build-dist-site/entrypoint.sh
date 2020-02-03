#!/usr/bin/env bash

set -e

echo "Starting deployment..."
REMOTE_REPO="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git clone -b source $REMOTE_REPO repo
cd repo

echo "Installing dependencies..."
bundle install

echo "Building website..."
/bin/sh ./updategitinfo.sh
JEKYLL_ENV=production bundle exec jekyll build --trace
echo "Jekyll build done"

cd build
echo "Publishing website"
rm -f README.md

git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .

git commit -m "Github Actions - $(date)"
echo "Build branch ready to go. Pushing to Github..."

git push --force $REMOTE_REPO source:master

rm -rf .git
cd ..
rm -rf repo
echo "Deployed!"
