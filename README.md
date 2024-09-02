# Asset Generator

Asset Generator is a Dart package that simplifies asset management in Flutter projects by generating code for asset paths and pre-caching images.

## Features

- Generates Dart code for asset paths.
- Provides a function for pre-caching images.
- Simplifies asset management.

## Installation

Add `asset_generator` to your `pubspec.yaml`:

```yaml
dependencies:
  asset_generator: ^1.1.0



asset_generator:
#flutter pub run asset_generator:generate
  images:
    - assets/images/

  icons:
    - assets/svg/

  output_dir: lib\omar\generated_images.dart #optional
  class_name: Assets  #optional
