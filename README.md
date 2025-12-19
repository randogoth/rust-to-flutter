Repository moved to [codeberg.org/randogoth/rust-to-flutter.git](https://codeberg.org/randogoth/rust-to-flutter.git)

### Rust to Flutter Build Script

This script compiles a Rust library for both Android and iOS and copies the generated libraries to the appropriate Flutter project directories.

#### Features:
- Installs missing cross-compilation targets.
- Compiles Rust for Android.
- Conditionally compiles Rust for iOS if running on macOS.
- Optionally includes `x86` and `x86_64` Android/iOS targets using the `-x` flag.
- Automatically cleans the build directory before compiling.
- Copies `.so` (Android) and `.dylib` (iOS) files to the Flutter project.

#### Usage:
1. Ensure the following are installed:
   - `cargo-ndk`: Install via `cargo install cargo-ndk`.
   - Android NDK (set `ANDROID_NDK_HOME` or `ANDROID_SDK_ROOT`).
   - Rust toolchains for iOS targets if compiling on macOS.

2. Run the script:
   ```bash
   ./rust_to_flutter.sh [-x] <path_to_rust_project> <path_to_flutter_project>
   ```

   - The optional `-x` flag includes `x86` and `x86_64` targets for Android.

#### Examples:
- Standard build for Android and (on macOS) iOS:
   ```bash
   ./rust_to_flutter.sh ./rust_project ./flutter_project
   ```
- Include `x86` and `x86_64` targets for Android:
   ```bash
   ./rust_to_flutter.sh -x ./rust_project ./flutter_project
   ```

#### Notes:
- Android libraries are copied to `android/app/src/main/jniLibs/<arch>`.
- iOS libraries are copied to the `ios` directory.

#### Additional Information:
- iOS compilation is skipped automatically if the script is not running on macOS.
- The script checks for missing Rust cross-compilation targets and installs them as needed.
