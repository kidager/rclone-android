#!/usr/bin/env bash
# Builds librclone.so for the four Android ABIs, plus checksums and third-party licenses, into dist/.
# Needs Go and the Android NDK (ANDROID_NDK_HOME). ANDROID_API is the minimum Android API level.
set -euo pipefail
cd "$(dirname "$0")"

: "${ANDROID_NDK_HOME:?set it to the Android NDK directory}"
api="${ANDROID_API:-21}"
toolchain="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin"
version="$(go list -m -f '{{.Version}}' github.com/rclone/rclone)"

rm -rf dist
mkdir dist

# abi, GOARCH, clang target, GOARM
build() {
	echo "Building rclone $version for $1"
	CC="$toolchain/$3$api-clang" GOOS=android GOARCH="$2" GOARM="${4:-}" CGO_ENABLED=1 \
		CGO_LDFLAGS="-fuse-ld=lld -Wl,--hash-style=both -Wl,-z,max-page-size=16384 -s -Wl,--version-script,$PWD/version-script.txt" \
		go build -tags noselfupdate -trimpath -buildvcs=false \
		-ldflags "-s -w -buildid= -X github.com/rclone/rclone/fs.Version=$version" \
		-o "dist/librclone-$version-$1.so" .
}

build armeabi-v7a arm armv7a-linux-androideabi 7
build arm64-v8a arm64 aarch64-linux-android
build x86 386 i686-linux-android
build x86_64 amd64 x86_64-linux-android

CC="$toolchain/aarch64-linux-android$api-clang" GOOS=android GOARCH=arm64 CGO_ENABLED=1 \
	go run github.com/google/go-licenses/v2@v2.0.1 report . --template licenses.tpl \
	> dist/THIRD_PARTY_LICENSES.txt

(cd dist && sha256sum ./*.so THIRD_PARTY_LICENSES.txt > SHA256SUMS)
