import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'widgets/metrics_widget.dart';

const _defaultLabel = "Core";
const _defaultWeight = 123;
const _initialWidgetSize = 200;

final _darkThemeSwitcher = ValueNotifier(false);

void main() {
  runApp(ValueListenableBuilder<bool>(
    valueListenable: _darkThemeSwitcher,
    builder: (context, isDarkTheme, child) {
      return MaterialApp(
        title: 'Tonal - UI Coding Challenge',
        theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        home: child,
      );
    },
    child: const Scaffold(
      body: SafeArea(
        child: MetricsWidgetPreview(),
      ),
    ),
  ));
}

class MetricsWidgetPreview extends StatefulWidget {
  const MetricsWidgetPreview({Key? key}) : super(key: key);

  @override
  State<MetricsWidgetPreview> createState() => _MetricsWidgetPreviewState();
}

class _MetricsWidgetPreviewState extends State<MetricsWidgetPreview> {
  late final TextEditingController _labelTextController;
  late final TextEditingController _weightTextController;

  var _labelValue = _defaultLabel;
  var _weightValue = _defaultWeight;
  var _sizeFactor = 1.0;

  String? _weightInputError;

  @override
  void initState() {
    super.initState();
    _labelTextController = TextEditingController(text: _labelValue);
    _weightTextController = TextEditingController(text: _weightValue.toString());
    _setupListeners();
  }

  void _setupListeners() {
    _labelTextController.addListener(() {
      final newLabel = _labelTextController.text.trim();
      setState(() => _labelValue = newLabel);
    });
    _weightTextController.addListener(() {
      final newWeight = _weightTextController.text.trim();
      final parsedValue = int.tryParse(newWeight) ?? 0;
      final clampedValue = parsedValue.clampWeight();
      if (clampedValue == parsedValue) {
        setState(() => _weightValue = parsedValue);
      }
    });
  }

  @override
  void dispose() {
    _labelTextController.dispose();
    _weightTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const FractionalOffset(0.5, 0.2),
          child: Container(
            // height: _initialWidgetSize * _sizeFactor, width: _initialWidgetSize * _sizeFactor,
            // constraints: BoxConstraints.loose(Size.square(_initialWidgetSize * _sizeFactor)),
            child: MetricsWidget(
              label: _labelValue,
              weight: _weightValue,
              preferredSize: _initialWidgetSize * _sizeFactor,
            ),
          ),
        ),
        Align(
          alignment: const FractionalOffset(0.5, .85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _labelTextController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          label: Text('Label'),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _weightTextController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(3),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            var newValueText = newValue.text;
                            while (newValueText.length > 1 && newValueText.startsWith('0')) {
                              newValueText = newValueText.replaceFirst('0', '');
                            }
                            return newValue.copyWith(
                                text: newValueText,
                                selection: TextSelection.collapsed(
                                    offset: min(newValueText.length, newValue.selection.baseOffset)));
                          }),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            _weightInputError = null;
                            if (newValue.text.isNotEmpty) {
                              final newValueInt = int.tryParse(newValue.text) ?? -1;
                              final newValueIntClamped = newValueInt.clampWeight();
                              if (newValueInt != newValueIntClamped) {
                                setState(() {
                                  _weightInputError =
                                      '${MetricsWidget.minWeightValue} - ${MetricsWidget.maxWeightValue}';
                                });
                                // return newValue;
                              }
                            }
                            return newValue;
                            // return newValue.copyWith(text: '$newValueInt');
                          })
                        ],
                        decoration: InputDecoration(
                          label: const Text(' '),
                          errorText: _weightInputError,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        const Text('Dark theme'),
                        Switch.adaptive(
                            value: _darkThemeSwitcher.value,
                            onChanged: (newValue) {
                              setState(() {
                                _darkThemeSwitcher.value = newValue;
                              });
                            }),
                      ],
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Widget size'),
                          Slider.adaptive(
                            value: _sizeFactor,
                            min: 0.5,
                            max: 2.0,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() => _sizeFactor = value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void tryIncrementWeight(int value) {
    final parsed = int.tryParse(_weightTextController.text) ?? -1;
    final clamped = parsed.clampWeight();
    if (parsed == clamped) {
      final newValue = parsed + value;
      final newClamped = newValue.clampWeight();
      if (newValue == newClamped) {
        _weightTextController.text = '$newValue';
      }
    }
  }
}

// A handy extension for clamping the 'weight' value
extension on int {
  int clampWeight() => clamp(MetricsWidget.minWeightValue, MetricsWidget.maxWeightValue) as int;
}
