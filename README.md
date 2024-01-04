# pokestrides

Derping and meming around with [flutter](https://docs.flutter.dev/). If:
- Android 10+: enable permissions to enable physical activity
  - Latest apk: [1.3.24-v0.2](https://drive.google.com/file/d/1OYvTdZhNSNoNmprPsJnYhkUHgr8nSuDH/view?usp=sharing)
- iOS: too lazy to boot up xcode to create IPA file

Main purpose: convince friends to run a half marathon, and attempt to motivate ppl while training P:

Known issues:
- [pedometer](https://pub.dev/packages/pedometer) library used is laggy on Android at times
- UI text bubbles can cover up images. Formatting's best effort tho, so this is gonna be a feature lolol

Given the first issue is kinda disappointing, probably won't be adding too many more features in here.

## Getting Started

Build app: `flutter run`
Build an Android binary: `flutter build apk`

### Setup
`brew install flutter`
or if you already have flutter installed: 
`flutter upgrade` 
grab dependencies:
`flutter pub get`

If you don't already have android/ios simulators:
- Easiest android setup is to download android studio:
`brew install --cask android-studio`
- use a mac for ios stuffs

Personally I prefer using vscode so i don't have to deal with xcode or android studio lag to use vscode flutter plugin to build/run/debug.

## Changelog

12.30:

<img width="361" alt="image" src="https://github.com/schen22/pokestrides/assets/6363626/960a37cc-f91f-4242-a3b4-b46e6dfb6206">

1.2:
- add transparent background to gif
- added gif animation
- play gif when walking
- pause gif when no movement is detected

1.3:
- added tap actions
- update quotes
- updated images

TODO:
- search for a more accurate pedometer library to use
- keep track of daily steps
- identify speed/distance
- track milestones
- look into reading data from google/apple fitness apps instead?