#!/bin/sh

echo "Should prettier be run?"
if ! echo $TRAVIS_PULL_REQUEST_BRANCH | grep -q "greenkeeper"; then
	echo "Not a GreenKeeper Pull Request, aborting"
	exit 0
fi

echo "Cloning repo"
git clone "https://"$GH_TOKEN"@github.com/"$TRAVIS_REPO_SLUG".git" repo
cd repo

echo "Switching to branch $TRAVIS_PULL_REQUEST_BRANCH"
git checkout $TRAVIS_PULL_REQUEST_BRANCH

# See if commit message includes "chore(package): update"
git log --name-status HEAD^..HEAD | grep "chore(package): update" || exit 0

echo "Running dev install"
npm i --only=dev

echo "Running prettier"
npm run prettier || $(npm bin)/prettier

echo "Commit and push"
git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"
git config --global push.default simple

git add .
git commit -m "chore: run prettier"
git push
