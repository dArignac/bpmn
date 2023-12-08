#!/bin/bash

if [[ ! -f apple-certificate-base64.txt ]] ; then
    echo "apple-certificate-base64.txt does not exists. Please create with base64 encoded Apple certificate as content!"
    exit
fi

echo "Building application for MacOS"
echo "Tauri Private Key:"
read TAURI_PRIVATE_KEY
echo "Tauri Private Key Password:"
read TAURI_KEY_PASSWORD
echo "Apple Signing Entity:"
read APPLE_SIGNING_IDENTITY
echo "Apple Cerfificate Password:"
read APPLE_CERTIFICATE_PASSWORD
echo "Apple ID:"
read APPLE_ID
echo "Apple Password:"
read APPLE_PASSWORD
echo "Apple Team ID:"
read APPLE_TEAM_ID

export TAURI_PRIVATE_KEY
export TAURI_KEY_PASSWORD
export APPLE_SIGNING_IDENTITY
export APPLE_CERTIFICATE=$(cat apple-certificate-base64.txt)
export APPLE_CERTIFICATE_PASSWORD
export APPLE_ID
export ENABLE_CODE_SIGNING=true
export APPLE_PASSWORD
export APPLE_TEAM_ID

yarn tauri build