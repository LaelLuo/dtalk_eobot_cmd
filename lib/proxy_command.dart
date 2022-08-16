import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dtalk/ext.dart';
import 'package:dtalk_robot/dtalk_robot.dart';

class ProxyCommand extends Command {
  ProxyCommand() : super() {
    argParser.addOption('path', abbr: 'p', help: 'proxy path');
    argParser.addOption('port', abbr: 'o', help: 'proxy port', defaultsTo: '8080');
    argParser.addOption('config', abbr: 'c', help: 'config file');
  }

  @override
  String description = '消息转发到钉钉机器人';

  @override
  String name = 'proxy';

  @override
  Future<void> run() async {
    final token = globalResults.getStringOrNull('token');
    final secret = globalResults.getStringOrNull('secret');
    final path = getStringOrNull('path');
    final port = getInt('port');
    final config = argResults?['config'];
    final dTalkMap = <String, DTalk>{};

    void addDTalk(String path, String? token, String? secret) {
      if (token == null || secret == null) return print('$path 参数不完整');
      dTalkMap[path] = DTalk(token: token, secret: secret);
    }

    if (config != null) {
      final configFile = File(config);
      if (configFile.existsSync()) {
        final List configList = json.decode(configFile.readAsStringSync());
        for (final configMap in configList) {
          final path = configMap['path'];
          if (path == null) continue;
          final token = configMap['token'];
          final secret = configMap['secret'];
          addDTalk(path, token, secret);
        }
      }
    } else if (path != null) {
      addDTalk(path, token, secret);
    } else {
      print('缺少path参数');
      return;
    }

    await startServer(port, dTalkMap);
  }

  Future<void> startServer(int port, Map<String, DTalk> dTalkMap) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('proxy server start at ${server.address.address}:${server.port}');

    await for (final request in server) {
      final path = request.uri.path;
      print('request path: $path');

      final dTalk = dTalkMap[path];
      if (dTalk == null) {
        request.response.statusCode = 404;
        request.response.close();
        continue;
      }

      final String? message;
      switch (request.method) {
        case 'POST':
          message = await utf8.decoder.bind(request).join();
          break;
        case 'GET':
          message = request.uri.queryParameters['message'];
          break;
        default:
          message = null;
          break;
      }
      if (message == null) {
        request.response.statusCode = 404;
      } else {
        await dTalk.sendMessage(message);
      }
      request.response.close();
    }
  }
}
