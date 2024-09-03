# Asset Generator

Asset Generator is a Dart package that simplifies asset management in Flutter projects by generating code for asset paths and pre-caching images.

## Features

- Generate Asset Paths: Automatically generates Dart code for asset paths using the command flutter pub run asset_generator:generate.
- Count Variables: Counts the number of variables used in your project with the command flutter pub run asset_generator:count.
- Replace Variables: Replaces variable values with variable names using the command flutter pub run asset_generator:replace.
- Import Image Class: Replaces variable values with variable names and imports the image class  with the command flutter pub run asset_generator:replace -import.

## Installation

Add `asset_generator` to your `pubspec.yaml`:

```yaml
dev_dependencies:
  asset_generator: ^1.3.0



asset_generator:
  images:
    - assets/images/

  icons:
    - assets/svg/

  output_dir: lib\omar\generated_images.dart #optional
  class_name: Assets  #optional
```

## Commands

### Generate Asset Paths

- Generate Dart code for asset paths:

```sh
flutter pub run asset_generator:generate
```

- This command will general a file in the output_dir and name class name as class_name frpm yaml
  
```dart
import 'package:flutter/material.dart';

class Assets {
  //This image are the images that is in the images in yaml 
  static const String cartActive = 'assets/images/cart-active.png'; 
  static const String cartInactive = 'assets/images/cart-inactive.png';
  static const String check = 'assets/images/check.png'; 

  //This image are the icons that is in the icons in yaml 
  static const String notificationActive = 'assets/svg/notification-active.svg';
  static const String notification = 'assets/svg/notification.svg';
  static const String seacrh = 'assets/svg/seacrh.svg';
}

Future<void> myPrecacheImage(BuildContext context) async {
  await Future.wait([
  //This image are the icons that is in the icons in yaml 

    precacheImage(const AssetImage(Assets.notificationActive), context),
    precacheImage(const AssetImage(Assets.notification), context),
    precacheImage(const AssetImage(Assets.seacrh), context),
  ]);
}
```

### Count Variables

- note:will need to use Generate Asset Paths first to work.
  
- Count the number of variables used in your project:

```sh
flutter pub run asset_generator:count
```

- Example:

```dart
import 'package:flutter/material.dart';

class Assets {
  //will place the number of image used
  static const String cartActive = 'assets/images/cart-active.png'; // Used 2 times
  static const String cartInactive = 'assets/images/cart-inactive.png';// Used 1 times
  static const String check = 'assets/images/check.png'; // Used 2 times

  static const String notificationActive = 'assets/svg/notification-active.svg';// Used 5 times
  static const String notification = 'assets/svg/notification.svg';// Used 0 times
  static const String seacrh = 'assets/svg/seacrh.svg';// Used 1 times
}

Future<void> myPrecacheImage(BuildContext context) async {
  await Future.wait([
  //This image are the icons that is in the icons in yaml 

    precacheImage(const AssetImage(Assets.notificationActive), context),
    precacheImage(const AssetImage(Assets.notification), context),
    precacheImage(const AssetImage(Assets.seacrh), context),
  ]);
}
```

### Replace Variables

- note:will need to use Generate Asset Paths first to work.

- Replace variable values with variable names:

```sh
flutter pub run asset_generator:replace
```

- Replace variable values with variable names and import the class if not import:

```sh
flutter pub run asset_generator:replace -import
```

-Example: above command will replace 'assets/images/cart-active.png' to Assets.cartActive
  