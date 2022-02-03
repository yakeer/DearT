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
    workFlows.value.add(_initFindMyCar());
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
        WorkFlowAction(6, WorkFlowActionType.closeWindows, delayInSeconds: 60));

    workFlow.actions.add(WorkFlowAction(7, WorkFlowActionType.stopCharging));

    workFlow.actions
        .add(WorkFlowAction(8, WorkFlowActionType.unlockChargePort));

    return workFlow;
  }

  WorkFlow _initFindMyCar() {
    WorkFlow workFlow = WorkFlow(preset: WorkFlowPreset.findMyCar);

    // Flash Immdietly
    workFlow.actions.add(
      WorkFlowAction(
        1,
        WorkFlowActionType.flash,
      ),
    );

    // Flash twice after 5 seconds
    workFlow.actions.add(
      WorkFlowAction(
        2,
        WorkFlowActionType.flash,
        delayInSeconds: 5,
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        3,
        WorkFlowActionType.flash,
        delayInSeconds: 6,
      ),
    );

    // Honk horn & flasg 4 times after 10 seconds
    workFlow.actions.add(
      WorkFlowAction(
        4,
        WorkFlowActionType.horn,
        delayInSeconds: 11,
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        5,
        WorkFlowActionType.flash,
        delayInSeconds: 12,
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        6,
        WorkFlowActionType.flash,
        delayInSeconds: 13,
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        7,
        WorkFlowActionType.flash,
        delayInSeconds: 14,
      ),
    );

    workFlow.actions.add(
      WorkFlowAction(
        8,
        WorkFlowActionType.flash,
        delayInSeconds: 15,
      ),
    );

    return workFlow;
  }

  Future<bool> startWorkFlow(
      {WorkFlow? workFlow, WorkFlowPreset? preset}) async {
    bool success = true;

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

    Future<bool> Function() actionToExecute;

    switch (workFlowAction.type) {
      case WorkFlowActionType.sentryOn:
        actionToExecute =
            () async => await vehicleController.toggleSentry(true);
        break;
      case WorkFlowActionType.sentryOff:
        actionToExecute =
            () async => await vehicleController.toggleSentry(false);
        break;
      case WorkFlowActionType.horn:
        actionToExecute = () async => await vehicleController.horn();
        break;
      case WorkFlowActionType.flash:
        actionToExecute = () async => await vehicleController.flashLights();
        break;
      case WorkFlowActionType.setTemperature:
        actionToExecute = () async => await vehicleController.setACTemperature(
              workFlowAction.arguments[0],
            );
        break;
      case WorkFlowActionType.acStart:
        actionToExecute = () async => await vehicleController.acStart();
        break;
      case WorkFlowActionType.acStop:
        actionToExecute = () async => await vehicleController.acStop();
        break;
      case WorkFlowActionType.startCharging:
        actionToExecute = () async => await vehicleController.startCharging();
        break;
      case WorkFlowActionType.stopCharging:
        actionToExecute = () async => await vehicleController.stopCharging();
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
          actionToExecute = () async => await vehicleController.unlockCharger();
        } else {
          actionToExecute = () async => true;
        }
        break;
      case WorkFlowActionType.startSteeringWheelHeat:
        actionToExecute =
            () async => await vehicleController.toggleSteeringWheelHeater(true);
        break;
      case WorkFlowActionType.stopSteeringWheelHeat:
        actionToExecute = () async =>
            await vehicleController.toggleSteeringWheelHeater(false);
        break;
      case WorkFlowActionType.startSeatHeater:
        actionToExecute = () async => await vehicleController.toggleSeatHeater(
              workFlowAction.arguments[0],
              workFlowAction.arguments[1],
            );
        break;
      case WorkFlowActionType.stopSeatHeater:
        actionToExecute = () async => await vehicleController.toggleSeatHeater(
              workFlowAction.arguments[0],
              0,
            );
        break;
      case WorkFlowActionType.workFlow:
        actionToExecute = () async =>
            await startWorkFlow(workFlow: workFlowAction.arguments[0]);
        break;
      case WorkFlowActionType.lockDoors:
        actionToExecute = () async => await vehicleController.doorLock();
        break;
      case WorkFlowActionType.unlockDoors:
        actionToExecute = () async => await vehicleController.doorUnlock();
        break;
      case WorkFlowActionType.ventWindows:
        actionToExecute = () async => await vehicleController.ventWindows();
        break;
      case WorkFlowActionType.closeWindows:
        actionToExecute = () async => await vehicleController.closeWindows();
        break;
    }

    // Check if we need a delay, or we can execute it immideitly.
    if (workFlowAction.delayInSeconds == null) {
      success = await actionToExecute();
    } else {
      Future.delayed(Duration(seconds: workFlowAction.delayInSeconds!),
          () async => await actionToExecute());
      success = true;
    }

    return success;
  }
}
