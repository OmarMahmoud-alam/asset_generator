import 'dart:convert';
import 'dart:io';

import 'package:asset_generator/src/generator/output.dart';
import 'package:path/path.dart';

import '../config/pubspec_config.dart';

import '../utils/file_utils.dart';
import '../utils/utils.dart';
import 'generator_exception.dart';


/// The generator of localization files.
class Generator {
  List<String>? _images;
  List<String>? _icons;
  late String _outputDir;

  /// Creates a new generator with configuration from the 'pubspec.yaml' file.
  Generator() {
    var pubspecConfig = ImageGeneratorConfig();
    var imageGeneratorConfig = ImageGeneratorConfig(); // Initialize the image generator config
final defaultOutputDir = join('lib', 'generated');

    // Initialize image and icon paths
    _images = imageGeneratorConfig.images;
    _icons = imageGeneratorConfig.icons;

    _outputDir = pubspecConfig.outputDir ?? defaultOutputDir; // Use outputDir from config or default
  }

  /// Generates localization files.
  Future<void> generateAsync() async {
    await _updateGeneratedDir();
   // await _generateDartFiles();
  }


  Future<void> _updateGeneratedDir() async {
    var content =
        generateAssetsDartFileContent(_images!); // Default values used here
    var formattedContent = formatDartContent(content, 'assets.dart');

    await updateAssetsDartFile(formattedContent, _outputDir);

    var intlDir = getIntlDirectory(_outputDir);
    if (intlDir == null) {
      await createIntlDirectory(_outputDir);
    }

   // await removeUnusedGeneratedDartFiles(locales, _outputDir);
  }

}