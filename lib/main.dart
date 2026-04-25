name: Flutter Build APK

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Re-Initialize Android Folder
        run: |
          # Wannan zai goge folder ta android dake da matsala ya sake ta sabuwa
          rm -rf android
          flutter create . --platforms android

      - name: Restore My Main Dart
        run: |
          # Tunda flutter create zai iya sake taba main.dart, wannan matakin zai tabbatar code dinka ya zauna
          # Za mu bar matakin gyara na biyu ya yi wannan
          flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
