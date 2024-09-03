import 'dart:io';
import 'package:asset_generator/src/config/pubspec_config.dart';
import 'package:path/path.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'dart:io';
import 'package:path/path.dart';
 String getRelativePath(String basePath, String targetPath) {
  // Normalize paths
  final base = normalize(basePath);
  final target = normalize(targetPath);

  // Get the relative path from basePath to targetPath
  final relativePath = relative(target, from: base);

   return relativePath.replaceAll(separator, '/');

}
class ReplaceImage {
  List<String>? _images;
  List<String>? _icons;
  late String _className;
  late String _outputDir;
  final bool _addImport;

 ReplaceImage({required bool addImport}) : _addImport = addImport {
    var imageGeneratorConfig = ImageGeneratorConfig(); // Initialize the image generator config
    final defaultOutputDir = join('lib', 'generated', 'generated_images.dart');
    _images = imageGeneratorConfig.images;
    _icons = imageGeneratorConfig.icons;
    _outputDir = imageGeneratorConfig.outputDir ?? defaultOutputDir;
    _className = imageGeneratorConfig.className ?? 'Assets';
  }

  Future<void> generateAsync() async {
    await _replaceImage();
  }
Future<void> _replaceImage() async {
  final directory = Directory('lib'); // Adjust this to your source directory
  final files = directory.listSync(recursive: true).where((file) => file is File && file.path.endsWith('.dart')).map((file) => file as File);

  final assetMap = await _generateAssetMapFromFile(_outputDir);

  for (var file in files) {
    if(file.path==_outputDir){
      continue;
    }
    final content = await file.readAsString();
    var modifiedContent = content;

    assetMap.forEach((assetPath, variableName) {
      modifiedContent = modifiedContent.replaceAll("'$assetPath'", '$_className.$variableName');
    });
var importPath="ijflkjapsfkafljk";
    if (modifiedContent != content) {
      importPath="import '${getRelativePath(file.path,_outputDir)}';";
      if ( !content.contains(importPath) &&_addImport) {
      modifiedContent = '$importPath\n\n$modifiedContent';
    }
      await file.writeAsString(modifiedContent);
      print('Updated ${file.path}');
    }
  }
 
}

Future<Map<String, String>> _generateAssetMapFromFile(String outputDir) async {
  final assetMap = <String, String>{};

  final file = File(outputDir);
  if (!await file.exists()) {
    print('Output directory file does not exist: $outputDir');
    return assetMap;
  }

  final content = await file.readAsString();
  final regex = RegExp(r"static const String (\w+) = '(.+?)';");

  for (final match in regex.allMatches(content)) {
    final variableName = match.group(1);
    final assetPath = match.group(2);

    if (variableName != null && assetPath != null) {
      assetMap[assetPath] = variableName;
    }
  }

  return assetMap;
}


}