import 'package:deart/controllers/vehicle_controller.dart';
import 'package:deart/models/internal/work_flow.dart';
import 'package:deart/models/internal/work_flow_action.dart';
import 'package:deart/models/internal/work_flow_action_type.dart';
import 'package:deart/models/internal/work_flow_preset.dart';
import 'package:get/get.dart';

class WorkFlowController extends GetxController {
  RxBool enabled = true.obs;
  Rx<List<WorkFlow>> workFlows = Rx([]);

  @override
  void onInit() {
    _initPresets();
    super.onInit();
  }

  void _initPresets() {
    workFlows.value.add(_initPreheat());
    workFlows.value.add(_initPrecool());
  }

  WorkFlow _initPreheat() {
    WorkFlow workFlow = WorkFlow(preset: WorkFlowPreset.preheat);

    workFlow.actions.add(
      WorkFlowAction(
        1,
        WorkFlowActionType.startSeatHeater,
        arguments: [0, 2],
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        2,
        WorkFlowActionType.setTemperature,
        arguments: [25.0],
      ),
    );

    workFlow.actions.add(WorkFlowAction(3, WorkFlowActionType.acStart));

    workFlow.actions
        .add(WorkFlowAction(4, WorkFlowActionType.startSteeringWheelHeat));

    workFlow.actions.add(WorkFlowAction(5, WorkFlowActionType.stopCharging));

    workFlow.actions
        .add(WorkFlowAction(6, WorkFlowActionType.unlockChargePort));

    return workFlow;
  }

  WorkFlow _initPrecool() {
    WorkFlow workFlow = WorkFlow(preset: WorkFlowPreset.precool);

    workFlow.actions.add(
      WorkFlowAction(
        1,
        WorkFlowActionType.stopSeatHeater,
        arguments: [0],
      ),
    );

    workFlow.actions
        .add(WorkFlowAction(2, WorkFlowActionType.stopSteeringWheelHeat));

    workFlow.actions.add(
      WorkFlowAction(
        3,
        WorkFlowActionType.setTemperature,
        arguments: [19.0],
      ),
    );

    workFlow.actions.add(WorkFlowAction(4, WorkFlowActionType.acStart));

    // Vent and close after 60 seconds
    workFlow.actions.add(WorkFlowAction(5, WorkFlowActionType.ventWindows));

    workFlow.actions.add(
        WorkFlowAction(6, WorkFlowActionType.closeWindows, arguments: [60]));

    workFlow.actions.add(WorkFlowAction(7, WorkFlowActionType.stopCharging));

    workFlow.actions
        .add(WorkFlowAction(8, WorkFlowActionType.unlockChargePort));

    return workFlow;
  }

  Future<bool> startWorkFlow(
      {WorkFlow? workFlow, WorkFlowPreset? preset}) async {
    bool success = false;

    workFlow ??=
        workFlows.value.firstWhere((element) => element.preset == preset);

    workFlow.actions.sort((a, b) => a.sequence.compareTo(b.sequence));

    for (var action in workFlow.actions) {
      if (workFlow.actions.indexOf(action) == 0) {
        await executeWorkFlowAction(action);
      } else {
        await Future.delayed(const Duration(seconds: 1),
            () async => await executeWorkFlowAction(action));
      }
    }

    return success;
  }

  Future<bool> executeWorkFlowAction(WorkFlowAction workFlowAction) async {
    bool success = false;

    var vehicleController = Get.find<VehicleController>();

    switch (workFlowAction.type) {
      case WorkFlowActionType.sentryOn:
        success = await vehicleController.toggleSentry(true);
        break;
      case WorkFlowActionType.sentryOff:
        success = await vehicleController.toggleSentry(false);
        break;
      case WorkFlowActionType.horn:
        success = await vehicleController.horn();
        break;
      case WorkFlowActionType.flash:
        success = await vehicleController.flashLights();
        break;
      case WorkFlowActionType.setTemperature:
        success = await vehicleController.setACTemperature(
          workFlowAction.arguments[0],
        );
        break;
      case WorkFlowActionType.acStart:
        success = await vehicleController.acStart();
        break;
      case WorkFlowActionType.acStop:
        success = await vehicleController.acStop();
        break;
      case WorkFlowActionType.startCharging:
        success = await vehicleController.startCharging();
        break;
      case WorkFlowActionType.stopCharging:
        success = await vehicleController.stopCharging();
        break;
      case WorkFlowActionType.unlockChargePort:
        if (vehicleController.vehicleData.value != null &&
            vehicleController
                .vehicleData.value!.chargeState.chargePortDoorOpen &&
            (vehicleController
                        .vehicleData.value!.chargeState.chargerPilotCurrent !=
                    null &&
                vehicleController
                        .vehicleData.value!.chargeState.chargerPilotCurrent! >
                    0)) {
          success = await vehicleController.unlockCharger();
        } else {
          success = true;
        }
        break;
      case WorkFlowActionType.startSteeringWheelHeat:
        success = await vehicleController.toggleSteeringWheelHeater(true);
        break;
      case WorkFlowActionType.stopSteeringWheelHeat:
        success = await vehicleController.toggleSteeringWheelHeater(false);
        break;
      case WorkFlowActionType.startSeatHeater:
        success = await vehicleController.toggleSeatHeater(
          workFlowAction.arguments[0],
          workFlowAction.arguments[1],
        );
        break;
      case WorkFlowActionType.stopSeatHeater:
        success = await vehicleController.toggleSeatHeater(
          workFlowAction.arguments[0],
          0,
        );
        break;
      case WorkFlowActionType.workFlow:
        success = await startWorkFlow(workFlow: workFlowAction.arguments[0]);
        break;
      case WorkFlowActionType.lockDoors:
        success = await vehicleController.doorLock();
        break;
      case WorkFlowActionType.unlockDoors:
        success = await vehicleController.doorUnlock();
        break;
      case WorkFlowActionType.ventWindows:
        success = await vehicleController.ventWindows();
        break;
      case WorkFlowActionType.closeWindows:
        if (workFlowAction.arguments.isNotEmpty) {
          Future.delayed(Duration(seconds: workFlowAction.arguments[0]),
              () async => await vehicleController.closeWindows());
          success = true;
        } else {
          success = await vehicleController.closeWindows();
        }

        break;
    }

    return success;
  }
}
