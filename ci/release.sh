#!/bin/sh
VERSION=$1
DATE=`date -u '+%Y-%m-%dT%H:%M:%SZ'`

sed -i 's/^version = ".*"$/version = "'"${VERSION}"'"/g' src-tauri/Cargo.toml
sed -i '/name = "remembrancer"/{ n; s/version = ".*"/version = "'"${VERSION}"'"/g }' src-tauri/Cargo.lock
sed -i 's/^    "version": ".*"$/    "version": "'"${VERSION}"'"/g' src-tauri/tauri.conf.json
sed -i 's/^  "version": ".*",$/  "version": "'"${VERSION}"'",/g' package.json
sed -i 's/^  "version": ".*",$/  "version": "'"${VERSION}"'",/g' package-lock.json
