#!/bin/bash

set -e

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <rust_project_folder> <flutter_project_folder>"
    exit 1
fi

# Convert to absolute paths
RUST_PROJECT_FOLDER=$(cd "$1" && pwd)
FLUTTER_PROJECT_FOLDER=$(cd "$2" && pwd)

# Supported targets for Android
ANDROID_ARCHS=("arm64-v8a" "armeabi-v7a" "x86_64" "x86")
ANDROID_TARGETS=("aarch64-linux-android" "armv7-linux-androideabi" "x86_64-linux-android" "i686-linux-android")
IOS_TARGETS=("aarch64-apple-ios" "x86_64-apple-ios")

# Check if on macOS for iOS targets
if [[ "$OSTYPE" == "darwin"* ]]; then
    INCLUDE_IOS_TARGETS=true
else
    INCLUDE_IOS_TARGETS=false
    echo "Skipping iOS targets as this is not a macOS environment."
fi

# Enter the Rust project folder
cd "$RUST_PROJECT_FOLDER" || exit
echo "Cleaning Build Directory"
cargo clean

# Compile for each Android architecture using cargo-ndk
for arch in "${ANDROID_ARCHS[@]}"; do
    echo "Compiling for Android architecture: $arch..."
    cargo ndk -t "$arch" build --release
done

# Compile for each iOS target if on macOS
if [ "$INCLUDE_IOS_TARGETS" = true ]; then
    for target in "${IOS_TARGETS[@]}"; do
        echo "Compiling for iOS target: $target..."
        cargo build --release --target "$target"
    done
fi


# Copy compiled libraries to Flutter project for Android
for i in "${!ANDROID_ARCHS[@]}"; do
    arch=${ANDROID_ARCHS[$i]}
    target=${ANDROID_TARGETS[$i]}
    RELEASE_DIR="target/$target/release"
    LIB_FILE=$(find "$RELEASE_DIR" -maxdepth 1 -name "lib*.so" | head -n 1)

    if [ -n "$LIB_FILE" ]; then
        DEST_DIR="$FLUTTER_PROJECT_FOLDER/android/app/src/main/jniLibs/$arch"
        mkdir -p "$DEST_DIR"
        cp "$LIB_FILE" "$DEST_DIR/"
        echo "Copied $arch library to $2/android/app/src/main/jniLibs/$arch"
    else
        echo "No .so files found for $arch in $RELEASE_DIR"
    fi
done

# Copy compiled libraries to Flutter project for iOS
if [ "$INCLUDE_IOS_TARGETS" = true ]; then
    IOS_DEST_DIR="$FLUTTER_PROJECT_FOLDER/ios"
    mkdir -p "$IOS_DEST_DIR"
    for target in "${IOS_TARGETS[@]}"; do
    	RELEASE_DIR="target/$target/release"
    	LIB_FILE=$(find "$RELEASE_DIR" -maxdepth 1 -name "lib*.so" | head -n 1)
    	if [ -n "$LIB_FILE" ]; then
    	    cp "$LIB_FILE" "$IOS_DEST_DIR/"
    	    echo "Copied $target library to $IOS_DEST_DIR"
    	else
    	    echo "No library found for $target in $RELEASE_DIR"
    	fi
    done
fi

echo "Compilation and library copying completed successfully."