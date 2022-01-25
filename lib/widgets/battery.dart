import 'package:deart/models/charge_state.dart';
import 'package:deart/utils/unit_utils.dart';
import 'package:flutter/material.dart';

class BatteryWidget extends StatelessWidget {
  final ChargeState? chargeState;
  const BatteryWidget({Key? key, required this.chargeState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => switchMode(),
      child: Row(
        children: [
          Icon(_getIcon()),
          Text(
            '${mileToKM(chargeState?.batteryRange) ?? 'N/A'}km (${chargeState?.batteryLevel ?? 'N/A'}%)',
          ),
        ],
      ),
    );
  }

  void switchMode() {}

  IconData _getIcon() {
    if (chargeState != null) {
      if (chargeState!.batteryLevel > 0 && chargeState!.batteryLevel <= 20) {
        return Icons.battery_alert_outlined;
      } else {
        return Icons.battery_std_outlined;
      }
    } else {
      return Icons.battery_unknown_outlined;
    }
  }
}
