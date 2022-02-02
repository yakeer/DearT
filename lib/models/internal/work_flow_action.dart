import 'package:deart/models/internal/work_flow_action_type.dart';

class WorkFlowAction {
  final int sequence;

  final WorkFlowActionType type;

  late List<dynamic> arguments;

  WorkFlowAction(
    this.sequence,
    this.type, {
    List<dynamic>? arguments,
  }) {
    if (arguments != null) {
      this.arguments = arguments;
    } else {
      this.arguments = [];
    }
  }
}
