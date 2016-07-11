#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o errexit

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made agains the $TRAVIS_BRANCH and not the master. Not deploying to Github pages"
  exit 0
fi

rm -rf output
mkdir output

# config
git config --global user.email "abk@mac.com"
git config --global user.name "Alex Kerney"

# build
nikola clean
nikola build

# deploy
cd output
git init
git add .
git commit -m "Deploy to Github Pages"
git push --force --quiet "https://${GITHUB_TOKEN}@$github.com/${GITHUB_REPO}.git" master:gh-pages > /dev/null 2>&1
