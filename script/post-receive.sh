#!/bin/bash
set -e

unset GIT_DIR
pushd ..

current="$(git symbolic-ref HEAD)"

while read oldrev newrev refname; do
  if [ "$refname" = "$current" ] && [ -n "${newrev//0}" ]; then
    git reset --hard
    bundle install --deployment | grep -v '^Using'
  fi
done
