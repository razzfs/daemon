import 'dart:convert';
import 'dart:io' as io;

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_printer.dart';
import 'package:logger/src/ansi_color.dart';
import 'package:stack_trace/stack_trace.dart';

// Modified version of the SimplePrinter from the logger library
class RazzPrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  final bool printTime = true;
  final bool colors = io.stdout.supportsAnsiEscapes;

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '\n${event.error}' : '';
    // stackStr will only print 'No stacktrace available.' if error was set.
    var stackStr = event.stackTrace != null ? '\n${Trace.format(event.stackTrace, terse: true)}' : (event.error != null ? '\nNo stacktrace available.' : '');
    var fullErrorStr = AnsiColor.fg(AnsiColor.grey(0.7))(errorStr + stackStr);
    var timeStr = printTime ? AnsiColor.fg(AnsiColor.grey(0.35))('[${DateTime.now().toIso8601String()}]') : '';
    return ['${_labelFor(event.level)} $timeStr $messageStr$fullErrorStr'];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level];
    var color = levelColors[level];

    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
