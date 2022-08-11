import 'dart:io';

import 'package:dtalk/base_command.dart';
import 'package:dtalk_robot/dtalk_robot.dart';

class RunCommand extends BaseCommand {
  RunCommand() : super('run', '执行命令');

  @override
  Future<void> run() async {
    final token = globalResults?['token'];
    final secret = globalResults?['secret'];
    if (token == null || secret == null) {
      print('token or secret is null');
      return;
    }
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('command is empty');
      return;
    }
    final commandString = rest.first;
    final command = commandString.split(RegExp(r' +'));
    final processResult = await Process.run(command.removeAt(0), command, runInShell: true);
    final builder = StringBuffer('执行命令: $commandString\n');
    builder.write('stdout: ${processResult.stdout}\n');
    builder.write('stderr: ${processResult.stderr}\n');
    final dTalk = DTalk(token: token, secret: secret);
    await dTalk.sendMessage(builder.toString());
  }
}
