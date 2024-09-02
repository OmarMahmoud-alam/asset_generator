import 'package:asset_generator/src/config/config_exception.dart';
import 'package:yaml/yaml.dart' as yaml;

import '../utils/file_utils.dart';

class ImageGeneratorConfig {
  List<String>? _images;
  List<String>? _icons;
   String? _outputDir;
  String? _className;



  ImageGeneratorConfig() {
    var pubspecFile = getPubspecFile();
    if (pubspecFile == null) {
      throw ConfigException("Can't find 'pubspec.yaml' file.");
    }

    var pubspecFileContent = pubspecFile.readAsStringSync();
    var pubspecYaml = yaml.loadYaml(pubspecFileContent);
    if (pubspecYaml is! yaml.YamlMap) {
      throw ConfigException(
          "Failed to extract config from the 'pubspec.yaml' file.\nExpected YAML map but got ${pubspecYaml.runtimeType}.");
    }

    var imageGeneratorConfig = pubspecYaml['asset_generator'];
    if (imageGeneratorConfig == null) {
throw('imageGeneratorConfig error');    }

   
    _images = imageGeneratorConfig['images'] is yaml.YamlList
        ? List<String>.from(imageGeneratorConfig['images'])
        : null;
    _icons = imageGeneratorConfig['icons'] is yaml.YamlList
        ? List<String>.from(imageGeneratorConfig['icons'])
        : null;
          _outputDir = imageGeneratorConfig['output_dir'] is String
        ? imageGeneratorConfig['output_dir']
        : null;
            _className = imageGeneratorConfig['class_name'] is String
        ? imageGeneratorConfig['class_name']
        : null;
  }

  List<String>? get images => _images;

  List<String>? get icons => _icons;
 String? get outputDir => _outputDir;
 String? get className => _className;


}
