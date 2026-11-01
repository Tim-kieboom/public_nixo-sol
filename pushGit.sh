#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
  echo "should have one argument (the commit message)"
  exit 1
fi

# always work inside this repo, and refuse to run if it is not its own git repo
# (e.g. when the folder sits inside a bigger repo such as a home directory)
cd "$(dirname "${BASH_SOURCE[0]}")"
if [ "$(git rev-parse --show-toplevel)" != "$(pwd -P)" ]; then
  echo "this folder is not the root of its own git repo, aborting"
  exit 1
fi

echo "fetching ..."
git fetch origin main

read -r ahead behind < <(git rev-list --left-right --count HEAD...origin/main)
if [ "$behind" -gt 0 ]; then
  echo "local branch is behind; pulling ..."
  git pull --rebase origin main
else
  echo "local branch is up to date (or ahead); skipping pull"
fi

echo "pushing ..."
git add -A
git commit -m "$1"
git push -u origin main
echo "GitHub Push successful!"
