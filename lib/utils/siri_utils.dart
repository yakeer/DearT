import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

List<FlutterSiriActivity> getSiriActivities() {
  List<FlutterSiriActivity> activities = [];

  activities.add(const FlutterSiriActivity(
    "Honk Horn",
    "deart_horn",
    isEligibleForSearch: true,
    isEligibleForPrediction: true,
    contentDescription: "Honk Horn",
    suggestedInvocationPhrase: "honk horn",
  ));

  activities.add(const FlutterSiriActivity(
    "Turn Sentry On",
    "deart_sentryOn",
    isEligibleForSearch: true,
    isEligibleForPrediction: true,
    contentDescription: "Activate Sentry Mode on my Tesla",
    suggestedInvocationPhrase: "activate sentry mode on my car",
  ));

  activities.add(
    const FlutterSiriActivity(
      "Turn Sentry Off",
      "deart_sentryOff",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Deactivate Sentry Mode on my Tesla",
      suggestedInvocationPhrase: "deactivate sentry mode on my car",
    ),
  );

  activities.add(const FlutterSiriActivity(
    "Unlock My Car",
    "deart_unlockDoors",
    isEligibleForSearch: true,
    isEligibleForPrediction: true,
    contentDescription: "Unlock my Tesla",
    suggestedInvocationPhrase: "unlock car",
  ));

  activities.add(
    const FlutterSiriActivity(
      "Lock My Car",
      "deart_lockDoors",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Lock my Tesla",
      suggestedInvocationPhrase: "lock car",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Open Charge Port",
      "deart_openChargePort",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Open Charge Port",
      suggestedInvocationPhrase: "open charge port",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Close Charge Port",
      "deart_closeChargePort",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Close Charge Port",
      suggestedInvocationPhrase: "close charge port",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Unlock Charger",
      "deart_unlockCharger",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Unlock Charger",
      suggestedInvocationPhrase: "unlock charger",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Start Charging",
      "deart_startCharging",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Start Charging",
      suggestedInvocationPhrase: "start charging",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Stop Charging",
      "deart_stopCharging",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Stop Charging",
      suggestedInvocationPhrase: "stop charging",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Vent Windows",
      "deart_ventWindows",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Vent Windows",
      suggestedInvocationPhrase: "Vent Windows",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Close Windows",
      "deart_closeWindows",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Close Windows",
      suggestedInvocationPhrase: "Close Windows",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Defrost Car (Preconditioning)",
      "deart_defrostCar",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Defrost Car (Preconditioning)",
      suggestedInvocationPhrase: "Defrost Car (Preconditioning)",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Stop Defrost Car",
      "deart_defrostCarOff",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Stop Defrost Car",
      suggestedInvocationPhrase: "Stop Defrost Car",
    ),
  );

  return activities;
}
