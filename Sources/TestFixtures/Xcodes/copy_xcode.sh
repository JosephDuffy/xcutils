#!/bin/sh

for XCODE_PATH in "$@"
do
    XCODE_NAME=$(basename "$XCODE_PATH")

    mkdir -p "$XCODE_NAME/Contents"
    cp "$XCODE_PATH/Contents/Info.plist" "$XCODE_NAME/Contents"
    cp "$XCODE_PATH/Contents/version.plist" "$XCODE_NAME/Contents"
done
