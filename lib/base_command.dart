import 'package:args/command_runner.dart';

class BaseCommand extends Command<void> {
  BaseCommand(this.name, this.description);

  @override
  final String name;

  @override
  final String description;
}