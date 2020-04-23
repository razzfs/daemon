/**
 * Entry point for the RazzFS daemon.
 *
 * This is a very basic CLI - the actual magic happens within master/ and volume/.
 */

import 'dart:io';

import 'package:logger/logger.dart';

import 'package:razzd/master/master.dart';
import 'package:razzd/razz_printer.dart';
import 'package:razzd/volume/volume.dart';

void main(List<String> arguments) async {
  var entryLogger = Logger(filter: ProductionFilter(), printer: RazzPrinter());

  if (arguments.length < 1) {
    entryLogger.e(
        'No arguments passed. If you are manually running this, please do not do so unless you know *exactly* what you are doing.');
  } else {
    try {
      final trueArgs = arguments.skip(1).toList();
      final type = arguments[0];

      if (type == 'master') {
        await masterDaemon(trueArgs);
      } else if (type == 'volume') {
        await volumeDaemon(trueArgs);
      } else {
        stdout.writeln('invalid type: ' + type);
      }
    } catch (e, stack) {
      entryLogger.wtf(
          'Exception made its way back up the call chain to entry point.', e, stack);
    }
  }
}
