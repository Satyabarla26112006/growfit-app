import 'package:flutter/material.dart';

import '../../services/weight_service.dart';

class WeightEntryScreen extends StatefulWidget {
  const WeightEntryScreen({
    super.key,
    this.goalWeight,
  });

  final double? goalWeight;

  @override
  State<WeightEntryScreen> createState() =>
      _WeightEntryScreenState();
}

class _WeightEntryScreenState
    extends State<WeightEntryScreen> {
  final TextEditingController _controller =
      TextEditingController();

  String? errorMessage;

  bool _saving = false;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.58);
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _error => Theme.of(context).colorScheme.error;
  Color get _border => Theme.of(context).colorScheme.outlineVariant;
  Color get _onPrimary => Theme.of(context).colorScheme.onPrimary;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // SAVE WEIGHT
  // ============================================================

  Future<void> _saveWeight() async {
    if (_saving) {
      return;
    }

    final text =
        _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        errorMessage =
            'Please enter your weight.';
      });

      return;
    }

    final weight =
        double.tryParse(text);

    if (weight == null ||
        weight <= 0) {
      setState(() {
        errorMessage =
            'Please enter a valid weight.';
      });

      return;
    }

    if (weight > 500) {
      setState(() {
        errorMessage =
            'Please enter a realistic weight.';
      });

      return;
    }

    setState(() {
      _saving = true;
      errorMessage = null;
    });

    try {
      await WeightService.addWeight(
        weight,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        errorMessage =
            'Could not save your weight. Please try again.';
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          _background,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        leading:
            IconButton(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(
                    context,
                  );
                },

          icon:
              Icon(
            Icons.arrow_back_rounded,
            color:
                _text,
          ),
        ),

        title:
            Text(
          'Add Weight',

          style:
              TextStyle(
            color:
                _text,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      body:
          SafeArea(
        child:
            ListView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),

          children: [
            _header(),

            const SizedBox(
              height: 25,
            ),

            _weightInput(),

            const SizedBox(
              height: 18,
            ),

            if (errorMessage != null)
              _errorMessage(),

            const SizedBox(
              height: 20,
            ),

            _quickValues(),

            const SizedBox(
              height: 28,
            ),

            _saveButton(),

            const SizedBox(
              height: 20,
            ),

            _infoCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Container(
      padding:
          const EdgeInsets.all(22),

      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,

          colors: [
            _secondary.withValues(alpha: 0.18),
            _surfaceElevated,
          ],
        ),

        borderRadius:
            BorderRadius.circular(24),

        border:
            Border.all(
          color:
              _secondary.withValues(
            alpha: 0.28,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Icon(
            Icons
                .monitor_weight_rounded,

            color:
                _secondary,

            size:
                36,
          ),

          SizedBox(
            width:
                14,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Track your progress',

                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        22,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                SizedBox(
                  height:
                      6,
                ),

                Text(
                  'Record your current weight to keep your progress up to date.',

                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize:
                        12,
                    height:
                        1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WEIGHT INPUT
  // ============================================================

  Widget _weightInput() {
    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration:
          BoxDecoration(
        color:
            _surfaceElevated,

        borderRadius:
            BorderRadius.circular(22),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha: 0.5,
          ),
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            'Current Weight',

            style:
                TextStyle(
              color:
                  _text,
              fontSize:
                  16,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height:
                14,
          ),

          TextField(
            controller:
                _controller,

            enabled:
                !_saving,

            keyboardType:
                const TextInputType
                    .numberWithOptions(
              decimal:
                  true,
            ),

            onChanged:
                (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },

            style:
                TextStyle(
              color:
                  _text,
              fontSize:
                  28,
              fontWeight:
                  FontWeight.w900,
            ),

            decoration:
                InputDecoration(
              hintText:
                  '0.0',

              hintStyle:
                  TextStyle(
                color:
                    _muted,
                fontSize:
                    28,
              ),

              suffixText:
                  'kg',

              suffixStyle:
                  TextStyle(
                color:
                    _secondary,
                fontSize:
                    18,
                fontWeight:
                    FontWeight.w800,
              ),

              filled:
                  true,

              fillColor:
                  _surface,

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),

                borderSide:
                    BorderSide.none,
              ),

              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),

                borderSide:
                    BorderSide(
                  color:
                      _border.withValues(
                    alpha:
                        0.5,
                  ),
                ),
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),

                borderSide:
                    BorderSide(
                  color:
                      _secondary,
                  width:
                      1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorMessage() {
    return Container(
      padding:
          const EdgeInsets.all(13),

      decoration:
          BoxDecoration(
        color:
            _error.withValues(
          alpha: 0.08,
        ),

        borderRadius:
            BorderRadius.circular(13),

        border:
            Border.all(
          color:
              _error.withValues(
            alpha: 0.25,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Icon(
            Icons.error_outline_rounded,

            color:
                _error,

            size:
                20,
          ),

          const SizedBox(
            width:
                9,
          ),

          Expanded(
            child:
                Text(
              errorMessage ?? '',

              style:
                  TextStyle(
                color:
                    _error,
                fontSize:
                    12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK VALUES
  // ============================================================

  Widget _quickValues() {
    const values = [
      '50',
      '55',
      '60',
      '65',
      '70',
      '75',
      '80',
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'Quick Select',

          style:
              TextStyle(
            color:
                _text,
            fontSize:
                13,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        const SizedBox(
          height:
              12,
        ),

        Wrap(
          spacing:
              9,

          runSpacing:
              9,

          children:
              values.map(
            (value) {
              return GestureDetector(
                onTap: _saving
                    ? null
                    : () {
                        setState(() {
                          _controller.text =
                              value;

                          _controller.selection =
                              TextSelection
                                  .fromPosition(
                            TextPosition(
                              offset:
                                  _controller.text.length,
                            ),
                          );

                          errorMessage =
                              null;
                        });
                      },

                child:
                    Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        16,

                    vertical:
                        10,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        _surfaceElevated,

                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),

                    border:
                        Border.all(
                      color:
                          _border,
                    ),
                  ),

                  child:
                      Text(
                    '$value kg',

                    style:
                        TextStyle(
                      color:
                          _text,
                      fontSize:
                          12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _saveButton() {
    return SizedBox(
      width:
          double.infinity,

      height:
          56,

      child:
          ElevatedButton.icon(
        onPressed:
            _saving
                ? null
                : _saveWeight,

        icon:
            _saving
                ? SizedBox(
                    width:
                        20,

                    height:
                        20,

                    child:
                        CircularProgressIndicator(
                      strokeWidth:
                          2.5,

                      color:
                          _onPrimary,
                    ),
                  )
                : const Icon(
                    Icons.check_rounded,
                  ),

        label:
            Text(
          _saving
              ? 'Saving...'
              : 'Save Weight',

          style:
              const TextStyle(
            fontSize:
                16,

            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget _infoCard() {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.info_outline_rounded,

            color:
                _primary,

            size:
                20,
          ),

          SizedBox(
            width:
                10,
          ),

          Expanded(
            child:
                Text(
              'For more consistent progress tracking, record your weight under similar conditions each time.',

              style:
                  TextStyle(
                color:
                    _muted,
                fontSize:
                    12,
                height:
                    1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}