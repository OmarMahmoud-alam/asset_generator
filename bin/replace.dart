library asset_generator;

import 'package:asset_generator/src/generator/generator_exception.dart';
import 'package:asset_generator/src/replace/replace.dart';
import 'package:asset_generator/src/utils/utils.dart';


Future<void> main(List<String> args) async {
    bool addImport = args.contains('-import');

  try {
   
    var generator = ReplaceImage(addImport: addImport);
    await generator.generateAsync();
  } on GeneratorException catch (e) {
    exitWithError(e.message);
  } catch (e) {
    exitWithError('Failed to generate localization files.\n$e');
  }
}
