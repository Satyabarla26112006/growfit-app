import 'package:flutter/material.dart';

import 'food_detail_screen.dart';

import '../../data/food_data.dart' as food_data;
import '../../models/food_model.dart' as food_model;

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({
    super.key,
    this.initialCategory,
    this.initialFood,
  });

  final String? initialCategory;
  final food_model.FoodModel? initialFood;

  @override
  State<FoodSearchScreen> createState() =>
      _FoodSearchScreenState();
}

class _FoodSearchScreenState
    extends State<FoodSearchScreen> {
  late final TextEditingController _controller;

  String query = '';

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted =>
      Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _border => Theme.of(context).colorScheme.outline;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController();

    if (widget.initialFood != null) {
      WidgetsBinding.instance
          .addPostFrameCallback(
        (_) {
          final food =
              widget.initialFood;

          if (food != null &&
              mounted) {
            _openFoodDetails(food);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // FOODS
  // ============================================================

  List<food_model.FoodModel> get foods {
    final category =
        widget.initialCategory;

    if (category != null &&
        category.trim().isNotEmpty) {
      final categoryFoods =
          food_data.FoodData.byCategory(
        category,
      );

      final searchText =
          query.trim().toLowerCase();

      if (searchText.isEmpty) {
        return categoryFoods;
      }

      return categoryFoods.where(
        (food) {
          return food.name
              .toLowerCase()
              .contains(searchText);
        },
      ).toList();
    }

    return food_data.FoodData.search(
      query,
    );
  }

  // ============================================================
  // OPEN FOOD DETAILS
  // ============================================================

  Future<void> _openFoodDetails(
    food_model.FoodModel food,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(
          food: food,
          meal: 'Snacks',
        ),
      ),
    );

    if (!mounted) return;
    setState(() {});
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final results = foods;

    return Scaffold(
      backgroundColor:
          _background,

      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        title: Text(
          widget.initialCategory ??
              'Search Food',
          style:
              TextStyle(
            color: _text,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),

            child: TextField(
              controller:
                  _controller,

              onChanged:
                  (value) {
                setState(() {
                  query = value;
                });
              },

              style:
                  TextStyle(
                color:
                    _text,
              ),

              decoration:
                  InputDecoration(
                hintText:
                    'Search food...',

                hintStyle:
                    TextStyle(
                  color:
                      _muted,
                ),

                prefixIcon:
                    Icon(
                  Icons
                      .search_rounded,
                  color:
                      _secondary,
                ),

                suffixIcon:
                    query.isEmpty
                        ? null
                        : IconButton(
                            onPressed:
                                () {
                              _controller
                                  .clear();

                              setState(() {
                                query =
                                    '';
                              });
                            },
                            icon:
                                Icon(
                              Icons
                                  .close_rounded,
                              color:
                                  _muted,
                            ),
                          ),

                filled:
                    true,

                fillColor:
                    _surface,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: _border.withValues(alpha: 0.16),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: _border.withValues(alpha: 0.20),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: _secondary,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child:
                results.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),

                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          18,
                          4,
                          18,
                          30,
                        ),

                        itemCount:
                            results.length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          return _foodCard(
                            results[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOD CARD
  // ============================================================

  Widget _foodCard(
    food_model.FoodModel food,
  ) {
    return GestureDetector(
      onTap: () {
        _openFoodDetails(food);
      },

      child:
          Container(
        margin:
            const EdgeInsets.only(
          bottom:
              11,
        ),

        padding:
            const EdgeInsets.all(
          15,
        ),

        decoration:
            BoxDecoration(
          color:
              _surface,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color:
                _border.withValues(
              alpha: 0.45,
            ),
          ),
        ),

        child:
            Row(
          children: [
            Container(
              width:
                  52,
              height:
                  52,

              decoration: BoxDecoration(
                color: _secondary.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _secondary.withValues(alpha: 0.10),
                ),
              ),

              child:
                  Icon(
                Icons
                    .restaurant_rounded,
                color:
                    _secondary,
              ),
            ),

            const SizedBox(
              width:
                  14,
            ),

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    food.name,
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color:
                          _text,
                      fontSize:
                          15,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height:
                        5,
                  ),

                  Text(
                    food.category,
                    style:
                        TextStyle(
                      color:
                          _muted,
                      fontSize:
                          11,
                    ),
                  ),

                  const SizedBox(
                    height:
                        5,
                  ),

                  Text(
                    '${food.calories.round()} kcal • '
                    'P ${food.protein.toStringAsFixed(1)}g • '
                    'C ${food.carbohydrates.toStringAsFixed(1)}g • '
                    'F ${food.fats.toStringAsFixed(1)}g',
                    style:
                        TextStyle(
                      color:
                          _muted,
                      fontSize:
                          10,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color:
                  _muted,
              size:
                  16,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyState() {
    return Center(
      child:
          Padding(
        padding:
            EdgeInsets.all(
          30,
        ),

        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Icon(
              Icons
                  .search_off_rounded,
              color:
                  _muted,
              size:
                  52,
            ),

            SizedBox(
              height:
                  14,
            ),

            Text(
              'No food found',
              style:
                  TextStyle(
                color:
                    _text,
                fontSize:
                    18,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            SizedBox(
              height:
                  5,
            ),

            Text(
              'Try another food name or category.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    _muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}