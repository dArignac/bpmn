#!/bin/sh
VERSION=`echo "$1" | cut -c2-`
# SIGNATURE_LINUX_FILE_DIR=$2
# SIGNATURE_MACOS_FILE_DIR=$3
# SIGNATURE_WINDOWS_FILE_DIR=$4
SIGNATURE_MACOS_FILE_DIR=$1

# restored from github artifacts
SIGNATURE_LINUX=`cat ${SIGNATURE_LINUX_FILE_DIR}/bpmn-modeler_*_amd64.AppImage.tar.gz.sig`
SIGNATURE_MACOS=`cat ${SIGNATURE_MACOS_FILE_DIR}/*.app.tar.gz.sig`
SIGNATURE_WINDOWS=`cat ${SIGNATURE_WINDOWS_FILE_DIR}/bpmn-modeler_*_x64_en-US.msi.zip.sig`
DATE=`date -u '+%Y-%m-%dT%H:%M:%SZ'`

    # "linux-x86_64": {
    #   "signature": "${SIGNATURE_LINUX}",
    #   "url": "https://github.com/dArignac/bpmn/releases/download/v${VERSION}/bpmn-modeler_${VERSION}_amd64.AppImage.tar.gz"
    # },
    # "windows-x86_64": {
    #   "signature": "${SIGNATURE_WINDOWS}",
    #   "url": "https://github.com/dArignac/bpmn/releases/download/v${VERSION}/bpmn-modeler_${VERSION}_x64_en-US.msi.zip"
    # }

tee update.json <<EOF
{
  "version": "${VERSION}",
  "notes": "n/a",
  "pub_date": "${DATE}",
  "platforms": {
    "darwin-x86_64": {
      "signature": "${SIGNATURE_MACOS}",
      "url": "https://github.com/dArignac/bpmn/releases/download/v${VERSION}/bpmn-modeler.app.tar.gz"
    }
  }
}
EOF