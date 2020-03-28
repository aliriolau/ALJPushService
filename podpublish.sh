#!/bin/sh

echo "Enter Spec Version: (e.g. 1.0.0)"

read version

git add .

git commit -m "${version} publish."

git push origin master

git tag ${version}

git push --tags

pod repo push \
 ccens-specs ALJPushService.podspec \
 --sources='git@39.100.75.14:ios/ccens-specs.git,https://github.com/CocoaPods/Specs.git' \
 --allow-warnings \
 --use-libraries
