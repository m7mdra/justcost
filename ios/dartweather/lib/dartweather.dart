import 'dart:io';
import 'package:args/args.dart';


main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addOption('zip', abbr: 'z')
    ..addOption('country', abbr: 'c', defaultsTo: 'de');

  final argResults = parser.parse(arguments);

  print(argResults.options.join(''));
}
