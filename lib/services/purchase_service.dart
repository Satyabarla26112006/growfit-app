import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/subscription_model.dart';
import 'subscription_service.dart';

class PurchaseService {
  PurchaseService._();

  static final InAppPurchase _inAppPurchase =
      InAppPurchase.instance;

  static StreamSubscription<List<PurchaseDetails>>?
      _purchaseSubscription;

  static bool _initialized = false;

  // ============================================================
  // PRODUCT IDS
  // ============================================================

  static const String plusMonthlyProductId =
      'growfit_plus_monthly';

  static const String proMonthlyProductId =
      'growfit_pro_monthly';

  static const Set<String> productIds = {
    plusMonthlyProductId,
    proMonthlyProductId,
  };

  // ============================================================
  // PRODUCTS
  // ============================================================

  static List<ProductDetails> _products = [];

  static List<ProductDetails> get products {
    return List.unmodifiable(_products);
  }

  static ProductDetails? get plusProduct {
    return _findProduct(plusMonthlyProductId);
  }

  static ProductDetails? get proProduct {
    return _findProduct(proMonthlyProductId);
  }

  static ProductDetails? _findProduct(
    String productId,
  ) {
    for (final product in _products) {
      if (product.id == productId) {
        return product;
      }
    }

    return null;
  }

  // ============================================================
  // STORE STATUS
  // ============================================================

  static bool _storeAvailable = false;

  static bool get isStoreAvailable {
    return _storeAvailable;
  }

  static String? _lastError;

  static String? get lastError {
    return _lastError;
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    _lastError = null;

    _purchaseSubscription =
        _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _lastError = error.toString();
      },
    );

    _storeAvailable =
        await _inAppPurchase.isAvailable();

    if (!_storeAvailable) {
      _lastError =
          'The app store is currently unavailable.';
      return;
    }

    await loadProducts();
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  static Future<void> loadProducts() async {
    _lastError = null;

    if (!_storeAvailable) {
      _storeAvailable =
          await _inAppPurchase.isAvailable();
    }

    if (!_storeAvailable) {
      _lastError =
          'The app store is currently unavailable.';
      _products = [];
      return;
    }

    final response =
        await _inAppPurchase.queryProductDetails(
      productIds,
    );

    if (response.error != null) {
      _lastError = response.error!.message;
      _products = response.productDetails;
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      _lastError =
          'Products not found: '
          '${response.notFoundIDs.join(', ')}';
    }

    _products = response.productDetails;
  }

  // ============================================================
  // PRICE HELPERS
  // ============================================================

  static String get plusPrice {
    return plusProduct?.price ?? 'Unavailable';
  }

  static String get proPrice {
    return proProduct?.price ?? 'Unavailable';
  }

  // ============================================================
  // PURCHASE PLUS
  // ============================================================

  static Future<bool> purchasePlus() async {
    return _purchaseProduct(
      plusProduct,
      SubscriptionPlan.plus,
    );
  }

  // ============================================================
  // PURCHASE PRO
  // ============================================================

  static Future<bool> purchasePro() async {
    return _purchaseProduct(
      proProduct,
      SubscriptionPlan.pro,
    );
  }

  // ============================================================
  // PURCHASE PRODUCT
  // ============================================================

  static Future<bool> _purchaseProduct(
    ProductDetails? product,
    SubscriptionPlan plan,
  ) async {
    _lastError = null;

    if (product == null) {
      _lastError =
          'This subscription is currently unavailable.';
      return false;
    }

    final purchaseParam = PurchaseParam(
      productDetails: product,
    );

    final started =
        await _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );

    if (!started) {
      _lastError =
          'The purchase could not be started.';
    }

    return started;
  }

  // ============================================================
  // PURCHASE STREAM
  // ============================================================

  static Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
  ) async {
    for (final purchase in purchases) {
      await _handlePurchase(purchase);
    }
  }

  // ============================================================
  // HANDLE PURCHASE
  // ============================================================

  static Future<void> _handlePurchase(
    PurchaseDetails purchase,
  ) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        // The store is still processing the purchase.
        return;

      case PurchaseStatus.error:
        _lastError =
            purchase.error?.message ??
                'The purchase failed.';
        await _completePurchaseIfNeeded(purchase);
        return;

      case PurchaseStatus.canceled:
        _lastError = 'Purchase canceled.';
        await _completePurchaseIfNeeded(purchase);
        return;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        final verified =
            await _verifyPurchase(purchase);

        if (verified) {
          await _deliverPurchase(purchase);
        } else {
          _lastError =
              'Purchase verification failed.';
        }

        await _completePurchaseIfNeeded(purchase);
        return;
    }
  }

  // ============================================================
  // VERIFY PURCHASE
  // ============================================================
  //
  // IMPORTANT:
  // Real production verification should happen on a trusted
  // backend using the App Store / Google Play receipt or token.
  //
  // This method intentionally does NOT grant Plus/Pro yet.
  //

  static Future<bool> _verifyPurchase(
    PurchaseDetails purchase,
  ) async {
    final verificationData =
        purchase.verificationData;

    final source =
        verificationData.source;

    final serverVerificationData =
        verificationData.serverVerificationData;

    if (source.isEmpty ||
        serverVerificationData.isEmpty) {
      return false;
    }

    // Backend verification will be implemented in the
    // next purchase-security stage.
    return false;
  }

  // ============================================================
  // DELIVER PURCHASE
  // ============================================================
  //
  // This is reached only after verification returns true.
  //

  static Future<void> _deliverPurchase(
    PurchaseDetails purchase,
  ) async {
    final plan =
        _planFromProductId(purchase.productID);

    if (plan == null) {
      _lastError =
          'Unknown subscription product: '
          '${purchase.productID}';
      return;
    }

    final transactionDate =
        DateTime.tryParse(
      purchase.transactionDate ?? '',
    );

    final platform =
        purchase.verificationData.source;

    switch (plan) {
      case SubscriptionPlan.plus:
        await SubscriptionService.upgradeToPlus(
          startDate:
              transactionDate ?? DateTime.now(),
          autoRenew: true,
          purchaseId: purchase.purchaseID,
          platform: platform,
        );
        break;

      case SubscriptionPlan.pro:
        await SubscriptionService.upgradeToPro(
          startDate:
              transactionDate ?? DateTime.now(),
          autoRenew: true,
          purchaseId: purchase.purchaseID,
          platform: platform,
        );
        break;

      case SubscriptionPlan.free:
        break;
    }
  }

  // ============================================================
  // PRODUCT → PLAN
  // ============================================================

  static SubscriptionPlan? _planFromProductId(
    String productId,
  ) {
    switch (productId) {
      case plusMonthlyProductId:
        return SubscriptionPlan.plus;

      case proMonthlyProductId:
        return SubscriptionPlan.pro;

      default:
        return null;
    }
  }

  // ============================================================
  // RESTORE PURCHASES
  // ============================================================

  static Future<void> restorePurchases() async {
    _lastError = null;

    if (!_storeAvailable) {
      _storeAvailable =
          await _inAppPurchase.isAvailable();
    }

    if (!_storeAvailable) {
      _lastError =
          'The app store is currently unavailable.';
      return;
    }

    await _inAppPurchase.restorePurchases();
  }

  // ============================================================
  // COMPLETE PURCHASE
  // ============================================================

  static Future<void> _completePurchaseIfNeeded(
    PurchaseDetails purchase,
  ) async {
    if (!purchase.pendingCompletePurchase) {
      return;
    }

    await _inAppPurchase.completePurchase(
      purchase,
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  static Future<void> dispose() async {
    await _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
    _initialized = false;
  }
}