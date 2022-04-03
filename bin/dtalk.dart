import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dtalk/proxy_command.dart';
import 'package:dtalk/send_command.dart';

Future<void> main(List<String> arguments) async {
  exitCode = 0;
  final CommandRunner<void> runner = CommandRunner<void>('dtalk', '给你的钉钉发消息');
  runner.addCommand(SendCommand());
  runner.addCommand(ProxyCommand());
  try {
    await runner.run(arguments);
  } catch (e) {
    stderr.writeln(e);
    exitCode = 2;
  }
}
