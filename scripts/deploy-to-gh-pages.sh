#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master. Not deploying to Github pages"
  exit 0
fi

rm -rf output
mkdir output

# config
rev=$(git rev-parse --short HEAD)

# build
nikola clean
nikola build

# deploy
cd output
git init
git config --global user.email "abk@mac.com"
git config --global user.name "Alex Kerney"

#git commit -m "Deploy to Github Pages"
#git push --force --quiet "https://${GITHUB_TOKEN}@$github.com/${GITHUB_REPO}.git" master:gh-pages > /dev/null 2>&1

git remote add upstream "https://${GITHUB_TOKEN}@$github.com/${GITHUB_REPO}.git"
git fetch upstream
git reset upstream/gh-pages

echo "mmsar.team" > CNAME

touch .

git add -A .
git commit -m "rebuild Github Pages by Travis at ${rev}"
git push -q upstream HEAD:gh-pages
