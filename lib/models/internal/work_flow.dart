import 'package:deart/models/internal/work_flow_action.dart';
import 'package:deart/models/internal/work_flow_preset.dart';

class WorkFlow {
  final WorkFlowPreset? preset;

  final String? name;

  late List<WorkFlowAction> actions;

  WorkFlow({this.preset, this.name}) {
    actions = [];
  }
}
