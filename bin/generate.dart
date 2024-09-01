library asset_generator;

import 'package:asset_generator/asset_generator.dart';
import 'package:asset_generator/src/generator/generator_exception.dart';
import 'package:asset_generator/src/utils/utils.dart';


Future<void> main(List<String> args) async {
  try {
    var e="daaaaaa";
        exitWithError('daaaaaaaaaaaaaaaaaaaaaaaaa$e');

   // var generator = Generator();
   // await generator.generateAsync();
  } on GeneratorException catch (e) {
    exitWithError(e.message);
  } catch (e) {
    exitWithError('Failed to generate localization files.\n$e');
  }
}
