import 'dart:io';
import 'package:path/path.dart' as path;

/// Generates Dart file content with constants for asset paths.
String generateAssetsDartFileContent(
    List<String> imagePaths,{ String className='Assets'}) {
  final buffer = StringBuffer();

  // Generate the imports and class definition
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln();
  buffer.writeln("class $className {");

  final files = <String>{};

  for (var imagePath in imagePaths) {
    final file = File(imagePath);
    final directory = Directory(imagePath);

    if (file.existsSync()) {
      // Add individual file
      files.add(imagePath);
    } else if (directory.existsSync()) {
      // Add all files in directory
      files.addAll(_listFilesInDirectory(directory));
    }
  }

  // Generate constants for each image path
  for (var filePath in files) {
    final name = path.basenameWithoutExtension(filePath).replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    buffer.writeln("  static const String $name = '$filePath';");
  }

  buffer.writeln("}");
  buffer.writeln();

  // Generate the precache function
  buffer.writeln("Future<void> myPrecacheImage(BuildContext context) async {");
  buffer.writeln("  await Future.wait([");

  for (var filePath in files) {
    final name = path.basenameWithoutExtension(filePath).replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    buffer.writeln("    precacheImage(const AssetImage($className.$name), context),");
  }

  buffer.writeln("  ]);");
  buffer.writeln("}");

  return buffer.toString();
}

/// Lists all files in a directory recursively.
Iterable<String> _listFilesInDirectory(Directory directory) sync* {
  final entities = directory.listSync(recursive: true, followLinks: false);
  for (var entity in entities) {
    if (entity is File) {
      yield entity.path;
    }
  }
}
