# pokestrides

Derping and meming around with [flutter](https://docs.flutter.dev/). If:
- Android 10+: enable permissions to enable physical activity
  - Latest apk: [1.3.24-v0.2](https://drive.google.com/file/d/1OYvTdZhNSNoNmprPsJnYhkUHgr8nSuDH/view?usp=sharing)
  - [1.1.24-v0.1 apk](https://drive.google.com/file/d/1YvbgClxDNn87RG0LV_C0QSdqhLNKrAmz/view?usp=drive_link)
- iOS: `open ios/Runner.xcworkspace` and update Signing & Capabilities > Team. 
  - Trust your newly created Development Certificate on your iOS device
     via Settings > General > Device Management > [your new certificate] > Trust
  - `flutter build ios --release`
  - Latest [1.3.24-v0.2 apk](https://drive.google.com/drive/folders/1Dimr6GIAUYeoQfbVwfJSXn8FmphlVhg5?usp=drive_link)

Main purpose: convince friends to run a half marathon, and attempt to motivate ppl while training P:

Known issues:
- [pedometer](https://pub.dev/packages/pedometer) library used is laggy on Android at times
- UI text bubbles can cover up images. Formatting's best effort tho, so this is gonna be a feature lolol

Given the first issue is kinda disappointing, probably won't be adding too many more features in here.

## Getting Started

- Build app: `flutter run`
- Build an Android binary: `flutter build apk`

### Setup
1. Install flutter: `brew install flutter`. 
2. Or if you already have flutter installed: `flutter upgrade` 
3. Grab dependencies: `flutter pub get`

If you don't already have android/ios simulators:
- Easiest android setup is to download android studio:
`brew install --cask android-studio`
- Use a mac for ios stuffs

Personally I prefer using vscode so i don't have to deal with xcode or android studio lag to use vscode flutter plugin to build/run/debug.

## Changelog

12.30:

<img width="200" alt="image" src="https://github.com/schen22/pokestrides/assets/6363626/960a37cc-f91f-4242-a3b4-b46e6dfb6206">

1.2:
- add transparent background to gif
- added gif animation
- play gif when walking
- pause gif when no movement is detected

1.3:
- added tap actions
- update quotes
- updated images
<img width="200" alt="image" src="https://github.com/schen22/pokestrides/assets/6363626/eacaedd8-c65b-4207-b9d6-24d180a2d41a">
<img width="200" alt="image" src="https://github.com/schen22/pokestrides/assets/6363626/e2d2d787-a66d-4783-b78f-90cc5eec689e">

Screen recording: https://drive.google.com/file/d/1-TzIMkSMWxAzrtB-y8N9Ed_kJBS1Iklz/view?usp=drive_link

TODO:
- search for a more accurate pedometer library to use
- keep track of daily steps
- identify speed/distance
- track milestones
- look into reading data from google/apple fitness apps instead?
