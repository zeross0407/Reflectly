#!/bin/bash
set -e

# Lấy thư mục project hiện tại
PROJECT_DIR=$(pwd)

# Định nghĩa thư mục cách ly trong project
DERIVED="$PROJECT_DIR/.xcode_derived"
MODULECACHE="$PROJECT_DIR/.xcode_modulecache"
PODCACHE="$PROJECT_DIR/.pod_cache"

mkdir -p "$DERIVED" "$MODULECACHE" "$PODCACHE"

echo "👉 Using isolated build dirs:"
echo "   DerivedData:   $DERIVED"
echo "   ModuleCache:   $MODULECACHE"
echo "   Pod cache:     $PODCACHE"
echo ""

# Xoá build cũ
flutter clean
flutter pub get

# Cài lại Pods với cache riêng
cd ios
rm -rf Pods Podfile.lock
COCOAPODS_CACHE_PATH="$PODCACHE" pod install --repo-update
cd ..

# Build iOS với cache riêng
xcodebuild \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -sdk iphonesimulator \
  -derivedDataPath "$DERIVED" \
  OTHER_SWIFT_FLAGS="-module-cache-path $MODULECACHE" \
  OTHER_CFLAGS="-fmodules-cache-path=$MODULECACHE"