### README for `rust_to_flutter.sh`

This script compiles a Rust library for both Android and iOS and copies the generated libraries to the appropriate Flutter project directories.

#### Features:
- Compiles Rust for Android using `cargo-ndk` for `arm64-v8a`, `armeabi-v7a`, `x86_64`, and `x86` architectures.
- Conditionally compiles Rust for iOS if running on macOS.
- Automatically cleans the build directory before compiling.
- Copies `.so` (Android) and `.a` (iOS) files to the Flutter project.

#### Usage:
1. Ensure the following are installed:
   - `cargo-ndk`: `cargo install cargo-ndk`
   - Android NDK (set `ANDROID_NDK_HOME` or `ANDROID_SDK_ROOT`)
   - Rust toolchains for iOS targets if compiling on macOS

2. Run the script:
   ```bash
   ./rust_to_flutter.sh <path_to_rust_project> <path_to_flutter_project>
   ```

#### Example:
```bash
./rust_to_flutter.sh ./rust_project ./flutter_project
```

#### Notes:
- Android libraries are copied to `android/app/src/main/jniLibs/<arch>`.
- iOS libraries are copied to the `ios` directory.
