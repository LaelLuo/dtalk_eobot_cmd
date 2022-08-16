import 'package:dtalk/base_command.dart';

class SendCommand extends BaseCommand {
  SendCommand() : super('send', '发消息给钉钉');

  @override
  Future<void> run() async {
    await super.run();
    final message = argResults?.rest.join(' ');
    if (message == null || message.isEmpty) {
      throw Exception('message is empty');
    }
    await dTalk.sendMessage(message);
  }
}
