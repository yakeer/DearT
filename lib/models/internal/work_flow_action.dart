import 'package:deart/models/internal/work_flow_action_type.dart';

class WorkFlowAction {
  final int sequence;

  final WorkFlowActionType type;

  late List<dynamic> arguments;

  int? delayInSeconds;

  WorkFlowAction(
    this.sequence,
    this.type, {
    List<dynamic>? arguments,
    this.delayInSeconds,
  }) {
    if (arguments != null) {
      this.arguments = arguments;
    } else {
      this.arguments = [];
    }
  }
}
