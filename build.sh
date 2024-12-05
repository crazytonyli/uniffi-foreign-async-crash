#!/bin/bash

set -euo pipefail
set -x

rm -rf target/swift-bindings && mkdir -p target/swift-bindings

cargo --config 'profile.dev.panic="abort"' build --lib --target aarch64-apple-darwin

for lib_name in my_core my_app; do
    cargo run --quiet --release --bin my_uniffi_bindgen generate \
        --library "./target/aarch64-apple-darwin/debug/lib${lib_name}.a" \
        --out-dir "target/swift-bindings" \
        --language swift
done

xcrun libtool -static -o target/swift-bindings/libForeignAsync.a \
    ./target/aarch64-apple-darwin/debug/libmy_core.a \
    ./target/aarch64-apple-darwin/debug/libmy_app.a

mkdir target/swift-bindings/Headers
mv target/swift-bindings/*.h target/swift-bindings/Headers
cp target/swift-bindings/*.swift swift/Sources/RustLib/

cat > target/swift-bindings/Headers/all.h <<EOF
#import "my_core.h"
#import "my_app.h"
EOF

cat > target/swift-bindings/Headers/module.modulemap <<EOF
module libForeignAsync {
  header "all.h"
  export *
}
EOF

rm -rf target/swift-bindings/libForeignAsync.xcframework
xcodebuild -create-xcframework \
    -library target/swift-bindings/libForeignAsync.a \
    -headers target/swift-bindings/Headers \
    -output target/swift-bindings/libForeignAsync.xcframework
