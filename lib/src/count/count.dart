import 'dart:io';
import 'package:asset_generator/src/config/pubspec_config.dart';
import 'package:path/path.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'dart:io';
import 'package:path/path.dart';

class CountImage {
  List<String>? _images;
  List<String>? _icons;
  late String _className;
  late String _outputDir;

  CountImage() {
    var imageGeneratorConfig = ImageGeneratorConfig(); // Initialize the image generator config
    final defaultOutputDir = join('lib', 'generated', 'generated_images.dart');
    _images = imageGeneratorConfig.images;
    _icons = imageGeneratorConfig.icons;
    _outputDir = imageGeneratorConfig.outputDir ?? defaultOutputDir;
    _className = imageGeneratorConfig.className ?? 'Assets';
  }

  Future<void> generateAsync() async {
    await _updateNoOfImage();
  }

  Future<void> _updateNoOfImage() async {
    final projectDir = Directory.current.path;
    final assetUsageCount = <String, int>{};

    // Recursively find all Dart files in the project directory
    final dartFiles = _findDartFiles(Directory(projectDir));

    for (final file in dartFiles) {
      final content = await File(file).readAsString();

      // Search for occurrences of asset paths in the Dart files
      for (final image in _images ?? []) {
        final assetName = '$image';
        final regExp = RegExp(r'\b' + RegExp.escape(assetName) + r'\b');

        final matches = regExp.allMatches(content).length;
        if (matches > 0) {
          assetUsageCount[image] = (assetUsageCount[image] ?? 0) + matches;
        }
      }

      // Also handle icons if needed
      for (final icon in _icons ?? []) {
        final assetName = '$_className.$icon';
        final regExp = RegExp(r'\b' + RegExp.escape(assetName) + r'\b');

        final matches = regExp.allMatches(content).length;
        if (matches > 0) {
          assetUsageCount[icon] = (assetUsageCount[icon] ?? 0) + matches;
        }
      }
    }

    // After counting, update the output file with the number of uses
    await _updateOutputFile(assetUsageCount);
  }

  List<String> _findDartFiles(Directory dir) {
    final dartFiles = <String>[];
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        dartFiles.add(entity.path);
      }
    }
    return dartFiles;
  }

  Future<void> _updateOutputFile(Map<String, int> assetUsageCount) async {
    final file = File(_outputDir);
    if (!file.existsSync()) {
      print('Output file does not exist.');
      return;
    }

    final content = await file.readAsString();
    final newContent = content.split('\n').map((line) {
      for (final entry in assetUsageCount.entries) {
        if (line.contains(entry.key)) {
          final newLine = '$line // Used ${entry.value} times';
          return newLine;
        }
      }
      return line;
    }).join('\n');

    await file.writeAsString(newContent);
    print('Updated asset usage counts.');
  }
}