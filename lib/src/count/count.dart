import 'dart:io';
import 'package:asset_generator/src/config/pubspec_config.dart';
import 'package:path/path.dart';


class CountImage {

  late String _className;
  late String _outputDir;

  CountImage() {
    var imageGeneratorConfig = ImageGeneratorConfig(); // Initialize the image generator config
    final defaultOutputDir = join('lib', 'generated', 'generated_images.dart');

    _outputDir = imageGeneratorConfig.outputDir ?? defaultOutputDir;
    _className = imageGeneratorConfig.className ?? 'Assets';
  }

  Future<void> generateAsync() async {
    await _updateNoOfImage();
  }

  Future<void> _updateNoOfImage() async {
    final projectDir = Directory.current.path;
    var assetUsageCount = <String, int>{};
  final assetNames = await extractAssetNames(_outputDir);

    // Recursively find all Dart files in the project directory
    final dartFiles = _findDartFiles(Directory(projectDir));

    for (final file in dartFiles) {
      final content = await File(file).readAsString();

      // Search for occurrences of asset paths in the Dart files
      for (final image in assetNames) {
        final assetName = '$_className.$image';
        final regExp = RegExp(r'\b' + RegExp.escape(assetName) + r'\b');

        final matches = regExp.allMatches(content).length;
        if (matches > 0) {
          assetUsageCount[image] = (assetUsageCount[image] ?? 0) + matches;
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
      final contentWithoutOldComments = content.split('\n').map((line) {
    // Remove comments of the form // Used X times
    final regExp = RegExp(r'\s*//\s*Used\s*\d+\s*times');
    return line.replaceAll(regExp, '').trimRight(); // Remove old comments and trailing spaces
  }).join('\n');
    final newContent = contentWithoutOldComments.split('\n').map((line) {
      for (final entry in assetUsageCount.entries) {
        if (line.contains(entry.key)) {
          final newLine = '$line // Used ${entry.value-1} times';
          return newLine;
        }
      }
      return line;
    }).join('\n');

    await file.writeAsString(newContent);
    print('Updated asset usage counts.');
  }
  Future<List<String>> extractAssetNames(String filePath) async {
  final content = await File(filePath).readAsString();

  // Regular expression to match variable names in the Assets class
  final regex = RegExp(r'static const String (\w+) =');

  // Find all matches
  final matches = regex.allMatches(content);

  // Extract the variable names
  final assetNames = matches.map((match) => match.group(1)!).toList();

  return assetNames;
}
}