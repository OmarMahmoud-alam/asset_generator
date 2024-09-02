import 'dart:io';

import 'package:asset_generator/src/generator/output.dart';
import 'package:path/path.dart';

import '../config/pubspec_config.dart';

import '../utils/file_utils.dart';
import '../utils/utils.dart';


/// The generator of localization files.
class Generator {
  List<String>? _images;
  List<String>? _icons;
 late String _className;
  late String _outputDir;

  /// Creates a new generator with configuration from the 'pubspec.yaml' file.
  Generator() {
 //   var pubspecConfig = ImageGeneratorConfig();
    var imageGeneratorConfig = ImageGeneratorConfig(); // Initialize the image generator config
final defaultOutputDir = join('lib', 'generated','generated_images.dart');
    // Initialize image and icon paths
    _images = imageGeneratorConfig.images;
    _icons = imageGeneratorConfig.icons;

    _outputDir = imageGeneratorConfig.outputDir ?? defaultOutputDir; // Use outputDir from config or default
      _className = imageGeneratorConfig.className ?? 'Assets'; 


  }

  /// Generates localization files.
  Future<void> generateAsync() async {
    await _updateGeneratedDir();
   // await _generateDartFiles();
  }


Future<void> _updateGeneratedDir() async {
  // Generate new Dart file content
  var content = generateAssetsDartFileContent(_icons, _images, className: _className);
  
  // Format the Dart content
  var formattedContent = formatDartContent(content, 'assets.dart');
  
  // Check if the output directory exists
  var outputFile = File(_outputDir);
  if (!outputFile.existsSync()) {
    await outputFile.create(recursive: true);
  }

  // Read the existing content if the file exists
  String? existingContent;
  if (outputFile.existsSync()) {
    existingContent = await outputFile.readAsString();
  }

  // Only update if the content has changed
  if (existingContent != formattedContent) {
    await updateAssetsDartFile(formattedContent, _outputDir);
    print('Updated assets.dart');
  } else {
    print('No changes detected, assets.dart is up-to-date.');
  }

  // Handle other operations like creating directories if needed
  var intlDir = getIntlDirectory(_outputDir);
  if (intlDir == null) {
    await createIntlDirectory(_outputDir);
  }

  // Optionally remove unused files if needed
  // await removeUnusedGeneratedDartFiles(locales, _outputDir);
}
}