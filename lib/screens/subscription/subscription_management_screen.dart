import 'package:flutter/material.dart';

import '../../models/subscription_model.dart';
import '../../models/user_model.dart';
import '../../services/purchase_service.dart';
import '../../services/user_service.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({
    super.key,
  });

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  UserModel? _user;

  bool _loading = true;
  bool _purchaseLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _loadUser();

    try {
      await PurchaseService.initialize();
    } catch (error) {
      debugPrint(
        'PurchaseService initialization failed: $error',
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  void _loadUser() {
    final user = UserService.getUser();

    if (!mounted) {
      _user = user;
      return;
    }

    setState(() {
      _user = user;
    });
  }

  String _planPrice(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Free';

      case SubscriptionPlan.plus:
        return PurchaseService.plusPrice;

      case SubscriptionPlan.pro:
        return PurchaseService.proPrice;
    }
  }

  String _planDescription(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Essential fitness and nutrition tracking.';

      case SubscriptionPlan.plus:
        return 'More insights, tracking and personalized features.';

      case SubscriptionPlan.pro:
        return 'The complete GrowFit experience with premium features.';
    }
  }

  List<String> _planFeatures(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return [
          'Basic fitness tracking',
          'Nutrition tracking',
          'Daily calorie targets',
          'Basic progress tracking',
        ];

      case SubscriptionPlan.plus:
        return [
          'Everything in Free',
          'Advanced nutrition insights',
          'Detailed progress analysis',
          'More personalized recommendations',
        ];

      case SubscriptionPlan.pro:
        return [
          'Everything in Plus',
          'Advanced fitness insights',
          'Premium recommendations',
          'Complete premium experience',
        ];
    }
  }

  bool _isCurrentPlan(SubscriptionPlan plan) {
    return _user?.subscription.plan == plan;
  }

  bool _canUpgradeTo(SubscriptionPlan plan) {
    final currentPlan =
        _user?.subscription.plan ?? SubscriptionPlan.free;

    return PurchaseService
            .products
            .any((product) => product.id == _productId(plan)) &&
        plan.index > currentPlan.index;
  }

  String? _productId(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return null;

      case SubscriptionPlan.plus:
        return PurchaseService.plusMonthlyProductId;

      case SubscriptionPlan.pro:
        return PurchaseService.proMonthlyProductId;
    }
  }

  Future<void> _selectPlan(
    SubscriptionPlan plan,
  ) async {
    if (_purchaseLoading) {
      return;
    }

    if (_isCurrentPlan(plan)) {
      return;
    }

    if (plan == SubscriptionPlan.free) {
      return;
    }

    if (!_canUpgradeTo(plan)) {
      _showMessage(
        'This subscription is currently unavailable.',
      );
      return;
    }

    setState(() {
      _purchaseLoading = true;
    });

    try {
      bool started = false;

      switch (plan) {
        case SubscriptionPlan.free:
          break;

        case SubscriptionPlan.plus:
          started = await PurchaseService.purchasePlus();
          break;

        case SubscriptionPlan.pro:
          started = await PurchaseService.purchasePro();
          break;
      }

      if (!mounted) {
        return;
      }

      if (started) {
        _showMessage(
          'Purchase started. Complete the payment in the store.',
        );
      } else {
        _showMessage(
          PurchaseService.lastError ??
              'Unable to start the purchase.',
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to start the purchase.',
      );

      debugPrint(
        'Subscription purchase error: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _purchaseLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    if (_purchaseLoading) {
      return;
    }

    setState(() {
      _purchaseLoading = true;
    });

    try {
      await PurchaseService.restorePurchases();

      if (!mounted) {
        return;
      }

      _loadUser();

      _showMessage(
        PurchaseService.lastError ??
            'Purchase restoration started.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to restore purchases.',
      );

      debugPrint(
        'Restore purchases error: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _purchaseLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _planName(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Free';

      case SubscriptionPlan.plus:
        return 'Plus';

      case SubscriptionPlan.pro:
        return 'Pro';
    }
  }

  Color _planAccent(
    BuildContext context,
    SubscriptionPlan plan,
  ) {
    final scheme = Theme.of(context).colorScheme;

    switch (plan) {
      case SubscriptionPlan.free:
        return scheme.onSurfaceVariant;

      case SubscriptionPlan.plus:
        return scheme.secondary;

      case SubscriptionPlan.pro:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_loading) {
      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          elevation: 0,
          title: const Text('Subscription'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = _user;

    if (user == null) {
      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          elevation: 0,
          title: const Text('Subscription'),
        ),
        body: Center(
          child: Text(
            'No user profile found.',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final subscription = user.subscription;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: Text(
          'Subscription',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentPlanCard(
                context,
                subscription,
              ),

              const SizedBox(height: 24),

              Text(
                'Choose your plan',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Upgrade whenever you are ready.',
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              ...SubscriptionPlan.values.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: _planCard(
                    context,
                    plan,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed:
                      _purchaseLoading
                          ? null
                          : _restorePurchases,
                  icon: const Icon(
                    Icons.restore_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'Restore Purchases',
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  'Purchases are securely processed by the app store.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentPlanCard(
    BuildContext context,
    SubscriptionModel subscription,
  ) {
    final scheme = Theme.of(context).colorScheme;

    final accent = _planAccent(
      context,
      subscription.plan,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.secondary,
            scheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: accent,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Plan',
                      style: TextStyle(
                        color:
                            scheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subscription.planName,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  subscription.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            _planDescription(
              subscription.plan,
            ),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          if (subscription.expiryDate != null) ...[
            const SizedBox(height: 12),
            Text(
              'Expires: ${_formatDate(subscription.expiryDate!)}',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context,
    SubscriptionPlan plan,
  ) {
    final scheme = Theme.of(context).colorScheme;

    final isCurrent = _isCurrentPlan(plan);

    final canUpgrade = _canUpgradeTo(plan);

    final accent = _planAccent(
      context,
      plan,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCurrent
              ? accent.withValues(alpha: 0.55)
              : scheme.outlineVariant.withValues(
                  alpha: 0.45,
                ),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: accent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      _planName(plan),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _planPrice(plan),
                      style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              if (isCurrent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CURRENT',
                    style: TextStyle(
                      color: accent,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            _planDescription(plan),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          ..._planFeatures(plan).map(
            (feature) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: accent,
                    size: 17,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isCurrent ||
                      _purchaseLoading
                  ? null
                  : canUpgrade
                      ? () => _selectPlan(plan)
                      : null,
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                disabledBackgroundColor:
                    scheme.surfaceContainerHighest,
                disabledForegroundColor:
                    scheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              child: _purchaseLoading &&
                      canUpgrade
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isCurrent
                          ? 'Current Plan'
                          : canUpgrade
                              ? 'Upgrade to ${_planName(plan)}'
                              : plan ==
                                      SubscriptionPlan.free
                                  ? 'Current Base Plan'
                                  : 'Unavailable',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}