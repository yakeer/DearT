import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

Future initSiriActivities() async {
  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Turn Sentry On",
      "sentryOnActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Activate Sentry Mode on my Tesla",
      suggestedInvocationPhrase: "activate sentry mode on my car",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Turn Sentry Off",
      "sentryOffActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Deactivate Sentry Mode on my Tesla",
      suggestedInvocationPhrase: "deactivate sentry mode on my car",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Unlock My Car",
      "unlockDoorsActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Unlock my Tesla",
      suggestedInvocationPhrase: "unlock car",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Lock My Car",
      "lockDoorsActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Lock my Tesla",
      suggestedInvocationPhrase: "lock car",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Open Charge Port",
      "openChargeActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Open Charge Port",
      suggestedInvocationPhrase: "open charge port",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Close Charge Port",
      "closeChargeActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Close Charge Port",
      suggestedInvocationPhrase: "close charge port",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Unlock Charger",
      "unlockChargerActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Unlock Charger",
      suggestedInvocationPhrase: "unlock charger",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Start Charging",
      "startChargingActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Start Charging",
      suggestedInvocationPhrase: "start charging",
    ),
  );

  await FlutterSiriSuggestions.instance.buildActivity(
    const FlutterSiriActivity(
      "Stop Charging",
      "stopChargingActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Stop Charging",
      suggestedInvocationPhrase: "stop charging",
    ),
  );
}
