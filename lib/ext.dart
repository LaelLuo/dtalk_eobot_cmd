import 'package:args/args.dart';
import 'package:args/command_runner.dart';

extension ArgResultsExt on ArgResults? {
  String? getStringOrNull(String tag) {
    final value = this?[tag];
    if (value is String?) return value;
    return value?.toString();
  }

  String getString(String tag) {
    final value = getStringOrNull(tag);
    if (value == null) throw FormatException('$tag not found');
    return value;
  }

  int? getIntOrNull(String tag) {
    final value = this?[tag];
    if (value is int?) return value;
    return int.tryParse(value.toString());
  }

  int getInt(String tag) {
    final value = getIntOrNull(tag);
    if (value == null) throw FormatException('$tag not found');
    return value;
  }
}

extension CommandExt on Command {
  String? getStringOrNull(String tag) => argResults.getStringOrNull(tag);

  String getString(String tag) => argResults.getString(tag);

  int? getIntOrNull(String tag) => argResults.getIntOrNull(tag);

  int getInt(String tag) => argResults.getInt(tag);
}

class Ext {}
