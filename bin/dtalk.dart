import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dtalk/proxy_command.dart';
import 'package:dtalk/run_command.dart';
import 'package:dtalk/send_command.dart';

Future<void> main(List<String> arguments) async {
  exitCode = 0;
  final CommandRunner<void> runner = CommandRunner<void>('dtalk', '给你的钉钉发消息');
  final argParser = runner.argParser;
  argParser.addOption('token', abbr: 't', help: 'dtalk token', mandatory: true);
  argParser.addOption('secret', abbr: 's', help: 'dtalk secret', mandatory: true);
  runner.addCommand(SendCommand());
  runner.addCommand(ProxyCommand());
  runner.addCommand(RunCommand());
  try {
    await runner.run(arguments);
  } catch (e) {
    stderr.writeln(e);
    exitCode = 2;
  }
}
