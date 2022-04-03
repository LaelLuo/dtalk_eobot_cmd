import 'package:dtalk/base_command.dart';
import 'package:dtalk_robot/dtalk_robot.dart';

class SendCommand extends BaseCommand {
  SendCommand() : super('send', '发消息给钉钉') {
    argParser.addOption('token', abbr: 't', help: 'dtalk token');
    argParser.addOption('secret', abbr: 's', help: 'dtalk secret');
  }

  @override
  Future<void> run() async {
    final token = argResults?['token'];
    final secret = argResults?['secret'];
    if (token == null || secret == null) {
      print('token or secret is null');
      return;
    }
    final message = argResults?.rest.join('\n');
    if (message == null || message.isEmpty) {
      print('message is empty');
      return;
    }
    final dTalk = DTalk(token: token, secret: secret);
    await dTalk.sendMessage(message);
  }
}
