import 'package:flutter/material.dart';

import '../../models/health_reading_model.dart';
import '../../services/health_reading_service.dart';

class HealthReadingsCard extends StatelessWidget {
  final VoidCallback onAddReading;

  const HealthReadingsCard({
    super.key,
    required this.onAddReading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final latestBp =
        HealthReadingService.latestBloodPressure;
    final latestGlucose =
        HealthReadingService.latestBloodGlucose;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monitor_heart_rounded,
                color: scheme.secondary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Health Readings',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onAddReading,
                icon: Icon(
                  Icons.add_rounded,
                  size: 16,
                ),
                label: Text(
                  'ADD',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: scheme.secondary,
                  textStyle: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Track your recent blood pressure and glucose readings.',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.62),
              fontSize: 10,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _readingTile(
                  scheme: scheme,
                  title: 'Blood Pressure',
                  icon:
                      Icons.favorite_rounded,
                  color: scheme.secondary,
                  primary: latestBp == null
                      ? '—'
                      : '${latestBp.systolic!.round()}/${latestBp.diastolic!.round()}',
                  secondary: latestBp == null
                      ? 'No reading'
                      : HealthReadingService
                          .classifyBloodPressure(
                            latestBp,
                          )
                          .label,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _readingTile(
                  scheme: scheme,
                  title: 'Blood Glucose',
                  icon:
                      Icons.water_drop_rounded,
                  color: scheme.tertiary,
                  primary: latestGlucose == null
                      ? '—'
                      : '${latestGlucose.glucoseMgDl!.round()}',
                  secondary: latestGlucose == null
                      ? 'No reading'
                      : '${HealthReadingService.classifyBloodGlucose(latestGlucose).label} mg/dL',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Reading labels are informational. Repeated or concerning results should be discussed with a healthcare professional.',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.62),
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingTile({
    required ColorScheme scheme,
    required String title,
    required IconData icon,
    required Color color,
    required String primary,
    required String secondary,
  }) {

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.62),
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            primary,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            secondary,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class HealthReadingEntrySheet
    extends StatefulWidget {
  const HealthReadingEntrySheet({
    super.key,
  });

  @override
  State<HealthReadingEntrySheet>
      createState() =>
          _HealthReadingEntrySheetState();
}

class _HealthReadingEntrySheetState
    extends State<HealthReadingEntrySheet> {
  HealthReadingType _type =
      HealthReadingType.bloodPressure;

  final _systolicController =
      TextEditingController();

  final _diastolicController =
      TextEditingController();

  final _glucoseController =
      TextEditingController();

  final _noteController =
      TextEditingController();

  DateTime _recordedAt =
      DateTime.now();

  bool _saving = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _glucoseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;

    final now = DateTime.now();

    try {
      setState(() {
        _saving = true;
      });

      if (_type ==
          HealthReadingType.bloodPressure) {
        final systolic = double.parse(
          _systolicController.text.trim(),
        );

        final diastolic = double.parse(
          _diastolicController.text.trim(),
        );

        final reading =
            HealthReadingModel(
          id: _id(now),
          recordedAt: _recordedAt,
          type:
              HealthReadingType.bloodPressure,
          systolic: systolic,
          diastolic: diastolic,
          note: _cleanNote(),
        );

        await HealthReadingService.add(
          reading,
        );
      } else {
        final glucose = double.parse(
          _glucoseController.text.trim(),
        );

        final reading =
            HealthReadingModel(
          id: _id(now),
          recordedAt: _recordedAt,
          type:
              HealthReadingType.bloodGlucose,
          glucoseMgDl: glucose,
          note: _cleanNote(),
        );

        await HealthReadingService.add(
          reading,
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } on FormatException {
      _showError(
        'Enter valid numeric values.',
      );
    } on ArgumentError catch (error) {
      _showError(
        error.message?.toString() ??
            'Enter valid values.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  String? _cleanNote() {
    final note =
        _noteController.text.trim();

    return note.isEmpty ? null : note;
  }

  String _id(DateTime date) {
    return 'health_${date.microsecondsSinceEpoch}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date == null ||
        !mounted) {
      return;
    }

    final time =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _recordedAt,
      ),
    );

    if (time == null ||
        !mounted) {
      return;
    }

    setState(() {
      _recordedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Health Reading',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _saving
                      ? null
                      : () => Navigator.pop(
                            context,
                          ),
                  icon: Icon(
                    Icons.close_rounded,
                    color: scheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<
                HealthReadingType>(
              segments: const [
                ButtonSegment(
                  value:
                      HealthReadingType
                          .bloodPressure,
                  label:
                      Text('Blood Pressure'),
                  icon: Icon(
                    Icons.favorite_rounded,
                  ),
                ),
                ButtonSegment(
                  value:
                      HealthReadingType
                          .bloodGlucose,
                  label:
                      Text('Glucose'),
                  icon: Icon(
                    Icons.water_drop_rounded,
                  ),
                ),
              ],
              selected: {_type},
              onSelectionChanged:
                  _saving
                      ? null
                      : (selection) {
                          setState(() {
                            _type =
                                selection.first;
                          });
                        },
            ),
            const SizedBox(height: 16),
            if (_type ==
                HealthReadingType.bloodPressure)
              Row(
                children: [
                  Expanded(
                    child: _numberField(
                      scheme: scheme,
                      controller:
                          _systolicController,
                      label: 'Systolic',
                      hint: '120',
                      suffix: 'mmHg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _numberField(
                      scheme: scheme,
                      controller:
                          _diastolicController,
                      label: 'Diastolic',
                      hint: '80',
                      suffix: 'mmHg',
                    ),
                  ),
                ],
              )
            else
              _numberField(
                scheme: scheme,
                controller:
                    _glucoseController,
                label:
                    'Blood Glucose',
                hint: '100',
                suffix: 'mg/dL',
              ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed:
                  _saving
                      ? null
                      : _pickDateTime,
              icon: Icon(
                Icons.schedule_rounded,
              ),
              label: Text(
                _dateTimeText(
                  _recordedAt,
                ),
              ),
              style:
                  TextButton.styleFrom(
                foregroundColor:
                    scheme.onSurface.withValues(alpha: 0.68),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller:
                  _noteController,
              maxLines: 2,
              style: TextStyle(
                color: scheme.onSurface,
              ),
              decoration:
                  InputDecoration(
                labelText: 'Note (optional)',
                labelStyle:
                    TextStyle(
                  color:
                      scheme.onSurface.withValues(alpha: 0.62),
                ),
                filled: true,
                fillColor:
                    scheme.surfaceContainerHighest.withValues(alpha: 0.60),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed:
                    _saving ? null : _save,
                icon: _saving
                    ? SizedBox(
                        width: 17,
                        height: 17,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : Icon(
                        Icons.save_rounded,
                      ),
                label: Text(
                  _saving
                      ? 'Saving...'
                      : 'Save Reading',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required ColorScheme scheme,
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(
        decimal: true,
      ),
      style: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      decoration:
          InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        labelStyle:
            TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.62),
        ),
        hintStyle:
            TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.38),
        ),
        suffixStyle:
            TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.48),
          fontSize: 9,
        ),
        filled: true,
        fillColor:
            scheme.surfaceContainerHighest.withValues(alpha: 0.60),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  String _dateTimeText(
    DateTime date,
  ) {
    final hour =
        date.hour % 12 == 0
            ? 12
            : date.hour % 12;

    final minute =
        date.minute.toString().padLeft(
              2,
              '0',
            );

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '${date.day}/${date.month}/${date.year} • $hour:$minute $period';
  }
}
