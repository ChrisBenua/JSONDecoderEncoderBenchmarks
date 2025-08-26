#!/bin/bash

swift build -c release --disable-sandbox
strip -rxST .build/arm64-apple-macosx/release/codable-benchmark-package-no-coding-keys
strip -rxST .build/arm64-apple-macosx/release/codable-benchmark-package
 
