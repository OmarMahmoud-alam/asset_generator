import 'dart:io';
import 'package:path/path.dart' as path;

/// Converts snake_case to camelCase and adds a prefix if the name starts with a number.
String _snakeToCamelCase(String text) {
  final camelCase = text.split('_').mapIndexed((index, part) {
    return index == 0 ? part : part[0].toUpperCase() + part.substring(1);
  }).join('');

  // If the camelCase name starts with a number, prefix it with an underscore.
  if (RegExp(r'^[0-9]').hasMatch(camelCase)) {
    return '_$camelCase';
  }

  return camelCase;
}

/// Generates Dart file content with constants for asset paths.
String generateAssetsDartFileContent(
    List<String>? icons,
    List<String>? images, {
    String className = 'Assets',
  }) {
  final buffer = StringBuffer();
  final imageFiles = <String>{};
  final iconFiles = <String>{};

  // Process image paths
  if (images != null) {
    for (var imagePath in images) {
      final file = File(imagePath);
      final directory = Directory(imagePath);

      if (file.existsSync()) {
        imageFiles.add(_normalizePath(imagePath));
      } else if (directory.existsSync()) {
        imageFiles.addAll(_listFilesInDirectory(directory));
      } else {
        throw ArgumentError('Invalid path: $imagePath');
      }
    }
  }

  // Process icon paths
  if (icons != null) {
    for (var iconPath in icons) {
      final file = File(iconPath);
      final directory = Directory(iconPath);

      if (file.existsSync()) {
        iconFiles.add(_normalizePath(iconPath));
      } else if (directory.existsSync()) {
        iconFiles.addAll(_listFilesInDirectory(directory));
      } else {
        throw ArgumentError('Invalid path: $iconPath');
      }
    }
  }

  // Generate the imports and class definition
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln();
  buffer.writeln("class $className {");

  // Generate constants for each image path
  for (var filePath in imageFiles) {
    final fileName = path.basenameWithoutExtension(filePath);
    final variableName = _snakeToCamelCase(fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'));
    buffer.writeln("  static const String $variableName = '$filePath';");
  }
   for (var filePath in iconFiles) {
    final fileName = path.basenameWithoutExtension(filePath);
    final variableName = _snakeToCamelCase(fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'));
    buffer.writeln("  static const String $variableName = '$filePath';");
  }

  buffer.writeln("}");
  buffer.writeln();

  // Generate the precache function
  buffer.writeln("Future<void> myPrecacheImage(BuildContext context) async {");
  buffer.writeln("  await Future.wait([");

  for (var filePath in iconFiles) {
    final fileName = path.basenameWithoutExtension(filePath);
    final variableName = _snakeToCamelCase(fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'));

    // Handle conflicts in the precache function
    buffer.writeln("    precacheImage(const AssetImage($className.$variableName), context),");
  }

  buffer.writeln("  ]);");
  buffer.writeln("}");

  return buffer.toString();
}

/// Normalizes the path to use forward slashes.
String _normalizePath(String filePath) {
  return filePath.replaceAll(r'\', '/');
}

/// Lists all files in a directory recursively and returns a set of paths.
Iterable<String> _listFilesInDirectory(Directory directory) sync* {
  final entities = directory.listSync(recursive: true, followLinks: false);
  for (var entity in entities) {
    if (entity is File) {
      yield _normalizePath(entity.path);
    }
  }
}

extension _IterableExtensions<T> on Iterable<T> {
  Iterable<E> mapIndexed<E>(E Function(int index, T element) f) sync* {
    var index = 0;
    for (final element in this) {
      yield f(index, element);
      index++;
    }
  }
}
