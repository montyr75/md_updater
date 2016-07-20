import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;

Logger log;

bool appDebugMode = false;

Logger initLog(String appName, bool debugMode) {
  appDebugMode = debugMode;

  DateFormat dateFormatter = new DateFormat("H:m:s.S");

  Logger.root.level = Level.ALL;

  if (debugMode) {
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
    });
  }

  return new Logger(appName);
}