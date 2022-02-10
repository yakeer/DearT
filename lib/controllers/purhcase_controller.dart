import 'dart:async';
import 'package:deart/models/purchase/package_type.dart';
import 'package:deart/utils/storage_utils.dart';
import 'package:deart/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseController extends GetxController {
  RxString title = 'In-App Purchases'.obs;
  Rx<List<ProductDetails>> products = Rx([]);
  Rx<List<ProductDetails>> availableProducts = Rx([]);
  Rx<List<ProductDetails>> purchasedProducts = Rx([]);
  RxBool isPurchasing = RxBool(false);
  late StreamSubscription _subscription;

  final Set<String> _productCatalogIds = <String>{
    'deart_multi_vehicle',
  };

  @override
  void onInit() {
    _listenToPurchaseUpdates();
    _getProducts();

    super.onInit();
  }

  Future _getProducts() async {
    try {
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_productCatalogIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      products.value = response.productDetails;
    } catch (e) {
      openPopup('In-app Purchases', 'Error retrieving products.');
    }

    await _loadPurchasedProducts();
  }

  Future _listenToPurchaseUpdates() async {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _processPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
      },
    );
  }

  _loadPurchasedProducts() async {
    List<ProductDetails> availableProductsList = products.value;

    String? purchasedProductsArray = await readStorageKey('purchasedProducts');
    if (purchasedProductsArray != null) {
      List<String> purchasedProductIds = purchasedProductsArray.split(',');

      List<ProductDetails> purchasedProductsList = [];
      for (var productId in purchasedProductIds) {
        ProductDetails? product = products.value
            .firstWhereOrNull((element) => element.id == productId);
        if (product != null) {
          purchasedProductsList.add(product);

          // Remove from available products
          availableProductsList.remove(product);
        }
      }

      purchasedProducts.value = purchasedProductsList;
    }
    availableProducts.value = availableProductsList;
  }

  void _processPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _showPendingUI();
          break;
        case PurchaseStatus.purchased:
          _deliverProduct(purchaseDetails.productID);
          _hidePendingUI();

          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.error:
          _handleError(purchaseDetails.error!);
          break;
        case PurchaseStatus.restored:
          _deliverProduct(purchaseDetails.productID);
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.canceled:
          _hidePendingUI();
          break;
      }
    }
  }

  _deliverProduct(String productId) async {
    // Update list
    ProductDetails product =
        products.value.firstWhere((element) => element.id == productId);

    availableProducts.value.remove(product);

    availableProducts.trigger(availableProducts.value);

    purchasedProducts.value.add(product);
    purchasedProducts.trigger(purchasedProducts.value);

    // Save to Storage
    String purchasedProductsArray =
        purchasedProducts.value.map((p) => p.id).join(',');
    await writeStorageKey(
      'purchasedProducts',
      purchasedProductsArray,
    );
  }

  _showPendingUI() {
    isPurchasing.value = true;
  }

  _hidePendingUI() {
    isPurchasing.value = false;
  }

  _handleError(IAPError error) {
    openPopup('Purchase Error', error.message);
  }

  void purchase(String productId) {
    final ProductDetails productDetails =
        products.value.firstWhere((element) => element.id == productId);
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    if (_isConsumable(productDetails)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  bool _isConsumable(ProductDetails product) {
    return false;
  }

  void restorePurchases() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      openPopup('Restore Purchases', 'Unexpected error');
    }
  }

  List<SettingsTile> getAvailableProducts(List<ProductDetails> availableList) {
    List<SettingsTile> tiles = [];

    if (availableList.isEmpty) {
      tiles.add(SettingsTile(
        title: 'Thanks!',
        trailing: null,
      ));
    } else {
      for (var element in availableList) {
        tiles.add(SettingsTile(
          title: element.title,
          onPressed: (context) => purchase(element.id),
        ));
      }
    }

    return tiles;
  }

  List<SettingsTile> getPurchasedProducts(List<ProductDetails> purchasedList) {
    List<SettingsTile> tiles = [];

    if (purchasedList.isEmpty) {
      tiles.add(SettingsTile(
        title: 'None',
      ));
    } else {
      for (var element in purchasedList) {
        tiles.add(SettingsTile(
          title: element.title,
          trailing: Container(),
          // onPressed: (context) => purchase(element.id),
        ));
      }
    }

    return tiles;
  }

  bool isEnabledFeature(PackageType packageType) {
    String? productId;

    switch (packageType) {
      case PackageType.multiVehicle:
        productId = 'deart_multi_vehicle';
        break;
      case PackageType.automations:
        productId = 'deart_automations';
        break;
      case PackageType.fullSubscription:
        productId = 'deart_subscription';
        break;
      case PackageType.siriShortcuts:
        productId = 'deart_siri_shortcuts';
        break;
      case PackageType.fullFeatures:
        productId = 'deart_full';
        break;
    }

    return purchasedProducts.value.any((element) => element.id == productId);
  }

  @override
  void onClose() {
    _subscription.cancel();

    super.onClose();
  }
}
