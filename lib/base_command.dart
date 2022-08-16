import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dtalk/ext.dart';
import 'package:dtalk_robot/dtalk_robot.dart';

abstract class BaseCommand extends Command<void> {
  BaseCommand(this.name, this.description) {
    argParser.addOption('token', abbr: 't', help: 'dtalk token');
    argParser.addOption('secret', abbr: 's', help: 'dtalk secret');
    argParser.addOption('config', abbr: 'c', help: 'config file');
  }

  @override
  final String name;

  @override
  final String description;

  late final String token;

  late final String secret;

  late final DTalk dTalk;

  @override
  Future<void> run() async {
    final configPath = getStringOrNull('config');
    if (configPath != null) {
      final file = File(configPath);
      if (!file.existsSync()) {
        throw Exception('config file not exists');
      }
      final config = json.decode(file.readAsStringSync());
      token = config['token'];
      secret = config['secret'];
      dTalk = DTalk(token: token, secret: secret);
    } else {
      token = getString('token');
      secret = getString('secret');
      dTalk = DTalk(token: token, secret: secret);
    }
  }
}
