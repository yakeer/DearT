import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

List<FlutterSiriActivity> getSiriActivities() {
  List<FlutterSiriActivity> activities = [];

  activities.add(const FlutterSiriActivity(
    "Turn Sentry On",
    "sentryOn",
    isEligibleForSearch: true,
    isEligibleForPrediction: true,
    contentDescription: "Activate Sentry Mode on my Tesla",
    suggestedInvocationPhrase: "activate sentry mode on my car",
  ));

  activities.add(
    const FlutterSiriActivity(
      "Turn Sentry Off",
      "sentryOff",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Deactivate Sentry Mode on my Tesla",
      suggestedInvocationPhrase: "deactivate sentry mode on my car",
    ),
  );

  activities.add(const FlutterSiriActivity(
    "Unlock My Car",
    "unlockDoors",
    isEligibleForSearch: true,
    isEligibleForPrediction: true,
    contentDescription: "Unlock my Tesla",
    suggestedInvocationPhrase: "unlock car",
  ));

  activities.add(
    const FlutterSiriActivity(
      "Lock My Car",
      "lockDoors",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Lock my Tesla",
      suggestedInvocationPhrase: "lock car",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Open Charge Port",
      "openChargePort",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Open Charge Port",
      suggestedInvocationPhrase: "open charge port",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Close Charge Port",
      "closeChargePort",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Close Charge Port",
      suggestedInvocationPhrase: "close charge port",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Unlock Charger",
      "unlockCharger",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Unlock Charger",
      suggestedInvocationPhrase: "unlock charger",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Start Charging",
      "startCharging",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Start Charging",
      suggestedInvocationPhrase: "start charging",
    ),
  );

  activities.add(
    const FlutterSiriActivity(
      "Stop Charging",
      "stopCharging",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Stop Charging",
      suggestedInvocationPhrase: "stop charging",
    ),
  );

  return activities;
}
