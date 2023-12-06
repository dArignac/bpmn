#!/bin/sh
VERSION=`echo "$1" | cut -c2-`
SIGNATURE_LINUX_FILE_DIR=$2
# SIGNATURE_MACOS_FILE_DIR=$3
SIGNATURE_WINDOWS_FILE_DIR=$3

# restored from github artifacts
SIGNATURE_LINUX=`cat ${SIGNATURE_LINUX_FILE_DIR}/bpmn-modeler_*_amd64.AppImage.tar.gz.sig`
# SIGNATURE_MACOS=`cat ${SIGNATURE_MACOS_FILE_DIR}/*.app.tar.gz.sig`
SIGNATURE_WINDOWS=`cat ${SIGNATURE_WINDOWS_FILE_DIR}/bpmn-modeler_*_x64_en-US.msi.zip.sig`
DATE=`date -u '+%Y-%m-%dT%H:%M:%SZ'`

# TODO MacOS has to be updated manually here AND in the JSON, FIXME maybe we write a script for this

tee update.json <<EOF
{
  "version": "${VERSION}",
  "notes": "n/a",
  "pub_date": "${DATE}",
  "platforms": {
    "linux-x86_64": {
      "signature": "${SIGNATURE_LINUX}",
      "url": "https://github.com/dArignac/bpmn/releases/download/v${VERSION}/bpmn-modeler_${VERSION}_amd64.AppImage.tar.gz"
    },
    "windows-x86_64": {
      "signature": "${SIGNATURE_WINDOWS}",
      "url": "https://github.com/dArignac/bpmn/releases/download/v${VERSION}/bpmn-modeler_${VERSION}_x64_en-US.msi.zip"
    },
    "darwin-x86_64": {
      "signature": "dW50cnVzdGVkIGNvbW1lbnQ6IHNpZ25hdHVyZSBmcm9tIHRhdXJpIHNlY3JldCBrZXkKUlVTbWhzc0ZBSTJVckQ1V2MzM3BuWTBMZklqSUF0WkZLNVJnRTdxcGVVajNRVkZnVDc5cENvZTRQazFQU21uL3l1MDg2VEM1ZHA2RzhhcWZCZzZzUzNpMzczMDZyRko1SWc4PQp0cnVzdGVkIGNvbW1lbnQ6IHRpbWVzdGFtcDoxNjkzODUxMjUyCWZpbGU6YnBtbi1tb2RlbGVyLmFwcC50YXIuZ3oKSmdKQSt0Vit1amVKbC9Na0RaUVZZY2toTld0VmdaaWNMMnd5YkN6QmtFNldHZTRSbkJFbWZKL05HNUdBWnp5QUtBdEUvenFkcmp2bU5aMVMzRldvRHc9PQo=",
      "url": "https://github.com/dArignac/bpmn/releases/download/v1.2.3/bpmn-modeler.app.tar.gz"
    },
  }
}
EOF