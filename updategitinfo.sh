#!/bin/sh

git log -1 --pretty=format:'{%n  "commitHash": "%h",%n  "date": "%aD",%n  "subject": "%s",%n  "author": "%aN" %n}' > ./_data/git.json
echo "Updated git information"
