import 'package:deart/controllers/home_controller.dart';
import 'package:deart/controllers/user_controller.dart';
import 'package:deart/models/enums/sentry_mode_state.dart';
import 'package:deart/widgets/theme/deart_icon_button.dart';
import 'package:deart/widgets/theme/deart_toggle_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionsWidget extends GetView<HomeController> {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ..._getSentryButton(),
          DearTIconButton(
            onTap: controller.horn,
            icon: Icons.volume_down_outlined,
            label: 'Horn',
          ),
          DearTIconButton(
            onTap: controller.carLocked.value
                ? controller.unlock
                : controller.lock,
            icon: controller.carLocked.value ? Icons.lock_open : Icons.lock,
            label: controller.carLocked.value ? 'Unlock' : 'Lock',
          ),
        ],
      ),
    );
  }

  List<Widget> _getSentryButton() {
    List<Widget> widgets = [];

    bool showToggle = Get.find<UserController>()
        .getPreference<bool>('sentryQuickActionToggle')!;

    if (showToggle) {
      widgets.add(
        DearTToggleIconButton(
          onStateTap: controller.turnOffSentry,
          offStateTap: controller.turnOnSentry,
          unknownStateTap: controller.turnOnSentry,
          icon: Icons.shield_outlined,
          onLabel: 'Sentry On',
          offLabel: 'Sentry Off',
          unknownLabel: 'Unknown',
          toggleState: _getSentryToggleState(controller.sentryModeState.value),
        ),
      );

      // Also add Flash
      widgets.add(
        DearTIconButton(
          onTap: controller.flashLights,
          icon: Icons.flourescent_outlined,
          label: 'Flash',
        ),
      );
    } else {
      widgets.add(
        DearTIconButton(
          onTap: controller.turnOnSentry,
          icon: Icons.add_moderator_outlined,
          label: 'Arm',
        ),
      );

      widgets.add(
        DearTIconButton(
          onTap: controller.turnOffSentry,
          icon: Icons.remove_moderator_outlined,
          label: 'Disarm',
        ),
      );
    }

    return widgets;
  }

  DearTToggleIconButtonState _getSentryToggleState(
      SentryModeState sentryState) {
    switch (sentryState) {
      case SentryModeState.unknown:
        return DearTToggleIconButtonState.unknown;
      case SentryModeState.off:
        return DearTToggleIconButtonState.off;
      case SentryModeState.on:
        return DearTToggleIconButtonState.on;
    }
  }
}
