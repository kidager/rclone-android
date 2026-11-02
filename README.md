# rclone-android

[rclone](https://rclone.org), unmodified, built for Android as `librclone.so` for each ABI. Apps ship it in
`jniLibs/<abi>/` and run it as an executable from `nativeLibraryDir`.

## Releases

Releases follow rclone: release `v1.73.0` is rclone v1.73.0. Each
[release](https://github.com/kidager/rclone-android/releases) has:

- `librclone-<rclone version>-<abi>.so` for `armeabi-v7a`, `arm64-v8a`, `x86` and `x86_64`
- `THIRD_PARTY_LICENSES.txt`, the licenses of rclone and every Go module built into it
- `SHA256SUMS`, to check them with `sha256sum -c SHA256SUMS`

The libraries are linked for API level 21 and up (the NDK's minimum) and aligned for 16 KB memory pages.

## Versions

- rclone and Go: `go.mod`. Dependabot opens a PR for each new rclone release; once merged, the release for that
  version is built and published.
- NDK: `NDK_VERSION` in `.github/workflows/build.yml`. Changing it, or Go, doesn't publish a new release: run the
  Build workflow by hand to rebuild the current release's files.

## Building

On a Linux x86_64 host with Go and the Android NDK:

```bash
ANDROID_NDK_HOME=/path/to/ndk ./build.sh
```

The files land in `dist/`.

## License

The build files in this repository are released into the public domain ([Unlicense](LICENSE)). The libraries are
rclone ([MIT](https://github.com/rclone/rclone/blob/master/COPYING)) and its dependencies, under the licenses listed
in each release's `THIRD_PARTY_LICENSES.txt`.
