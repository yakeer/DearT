import 'package:deart/controllers/purhcase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class InAppPurchasesScreen extends GetView<PurchaseController> {
  const InAppPurchasesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PurchaseController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('${controller.title}'),
        ),
        body: controller.isPurchasing.value
            ? const Center(child: CircularProgressIndicator())
            : SettingsList(
                backgroundColor: Colors.black,
                sections: [
                  SettingsSection(
                    title: 'Purchased',
                    tiles: controller.getPurchasedProducts(
                        controller.purchasedProducts.value),
                  ),
                  SettingsSection(
                    title: 'Available to purchase',
                    tiles: controller.getAvailableProducts(
                        controller.availableProducts.value),
                  ),
                  SettingsSection(
                    title: 'Restore',
                    tiles: [
                      SettingsTile(
                        title: 'Restore Purchases',
                        onPressed: (context) => controller.restorePurchases(),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
