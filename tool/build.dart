import 'dart:io';
import 'package:path/path.dart' as path;

final String sdkBinDir = path.dirname(Platform.executable);
final String scriptSuffix = Platform.isWindows ? '.bat' : '';
final String executableSuffix = Platform.isWindows ? '.exe' : '';
final String dart2native = path.join(sdkBinDir, 'dart2native${scriptSuffix}');

main() {
  Process.runSync(dart2native, [
    'bin/main.dart',
    '-o',
    'out/razzd' + executableSuffix
  ]);
}