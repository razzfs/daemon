import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  ArgResults argResults = parser.parse(arguments);

  stdout.writeln('Hello world!');
}