import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/calculator_theme.dart';
import '../core/math_parser.dart';

class ScientificView extends StatelessWidget {
  final String expression;
  final String result;
  final AngleUnit angleUnit;
  final bool isShift;
  final bool isAlpha;
  final ValueChanged<String> onButtonPressed;

  const ScientificView({
    super.key,
    required this.expression,
    required this.result,
    required this.angleUnit,
    required this.isShift,
    required this.isAlpha,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<_KeyConfig>> keyRows = [
      // Row 1: Mode & Control Keys
      [
        _KeyConfig(
          action: 'SHIFT',
          primaryLabel: 'SHIFT',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificAltText,
          isGlow: isShift,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: 'ALPHA',
          primaryLabel: 'ALPHA',
          color: CalculatorTheme.keyScientific,
          textColor: Colors.cyanAccent,
          isGlow: isAlpha,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: 'DEG/RAD',
          primaryLabel: 'DEG/RAD',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: 'MODE',
          primaryLabel: 'MODE',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: 'AC',
          primaryLabel: 'AC',
          color: CalculatorTheme.keyUtility,
          textColor: CalculatorTheme.utilityText,
          haptic: HapticFeedback.heavyImpact,
        ),
      ],
      // Row 2: Trigonometric & Power Keys
      [
        _KeyConfig(
          action: isShift ? 'asin(' : 'sin(',
          primaryLabel: isShift ? 'sin⁻¹' : 'sin',
          secondaryLabel: 'sin⁻¹',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: 'asin(',
        ),
        _KeyConfig(
          action: isShift ? 'acos(' : 'cos(',
          primaryLabel: isShift ? 'cos⁻¹' : 'cos',
          secondaryLabel: 'cos⁻¹',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: 'acos(',
        ),
        _KeyConfig(
          action: isShift ? 'atan(' : 'tan(',
          primaryLabel: isShift ? 'tan⁻¹' : 'tan',
          secondaryLabel: 'tan⁻¹',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: 'atan(',
        ),
        _KeyConfig(
          action: isShift ? 'root(' : '^',
          primaryLabel: isShift ? '∛' : 'xʸ',
          secondaryLabel: '∛',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: 'root(',
        ),
        _KeyConfig(
          action: 'DEL',
          primaryLabel: 'DEL',
          color: CalculatorTheme.keyUtility,
          textColor: CalculatorTheme.utilityText,
          haptic: HapticFeedback.mediumImpact,
        ),
      ],
      // Row 3: Logarithmic, Root & Parentheses Keys
      [
        _KeyConfig(
          action: isShift ? '10^(' : 'log(',
          primaryLabel: isShift ? '10ˣ' : 'log',
          secondaryLabel: '10ˣ',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: '10^(',
        ),
        _KeyConfig(
          action: isShift ? 'e^(' : 'ln(',
          primaryLabel: isShift ? 'eˣ' : 'ln',
          secondaryLabel: 'eˣ',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: 'e^(',
        ),
        _KeyConfig(
          action: isShift ? '²' : '√(',
          primaryLabel: isShift ? 'x²' : '√',
          secondaryLabel: 'x²',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
          swipeUpAction: '²',
        ),
        _KeyConfig(
          action: '(',
          primaryLabel: '(',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: ')',
          primaryLabel: ')',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.lightImpact,
        ),
      ],
      // Row 4: Numbers 7-9, Division & Pi
      [
        _KeyConfig(
          action: '7',
          primaryLabel: '7',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '8',
          primaryLabel: '8',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '9',
          primaryLabel: '9',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '÷',
          primaryLabel: '÷',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: 'π',
          primaryLabel: 'π',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
      ],
      // Row 5: Numbers 4-6, Multiplication & Euler Constant
      [
        _KeyConfig(
          action: '4',
          primaryLabel: '4',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '5',
          primaryLabel: '5',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '6',
          primaryLabel: '6',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '×',
          primaryLabel: '×',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: 'e',
          primaryLabel: 'e',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
      ],
      // Row 6: Numbers 1-3, Subtraction & Answer Memory
      [
        _KeyConfig(
          action: '1',
          primaryLabel: '1',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '2',
          primaryLabel: '2',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '3',
          primaryLabel: '3',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '-',
          primaryLabel: '-',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: 'Ans',
          primaryLabel: 'Ans',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
      ],
      // Row 7: Number 0, Decimal, EXP, Addition & Equals
      [
        _KeyConfig(
          action: '0',
          primaryLabel: '0',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '.',
          primaryLabel: '.',
          color: CalculatorTheme.keyNumber,
          textColor: CalculatorTheme.numberText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: 'EXP',
          primaryLabel: 'EXP',
          color: CalculatorTheme.keyScientific,
          textColor: CalculatorTheme.scientificText,
          haptic: HapticFeedback.lightImpact,
        ),
        _KeyConfig(
          action: '+',
          primaryLabel: '+',
          color: CalculatorTheme.keyOperator,
          textColor: CalculatorTheme.operatorText,
          haptic: HapticFeedback.mediumImpact,
        ),
        _KeyConfig(
          action: '=',
          primaryLabel: '=',
          color: Colors.transparent,
          textColor: Colors.black,
          gradient: CalculatorTheme.equalsGradient,
          isGlow: true,
          haptic: HapticFeedback.heavyImpact,
        ),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          for (int r = 0; r < keyRows.length; r++) ...[
            if (r > 0) const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  for (int c = 0; c < keyRows[r].length; c++) ...[
                    if (c > 0) const SizedBox(width: 10),
                    Expanded(
                      child: _buildKeyWidget(keyRows[r][c]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyWidget(_KeyConfig config) {
    Widget buttonContent = _NeumorphicKeyWrapper(
      onTap: () {
        config.haptic();
        onButtonPressed(config.action);
      },
      color: config.color,
      gradient: config.gradient,
      isGlow: config.isGlow,
      child: config.secondaryLabel != null && config.secondaryLabel!.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    config.secondaryLabel!,
                    style: TextStyle(
                      color: isShift
                          ? CalculatorTheme.scientificAltText
                          : CalculatorTheme.scientificAltText.withValues(alpha: 0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    config.primaryLabel,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: config.textColor,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  config.primaryLabel,
                  style: TextStyle(
                    fontSize: config.primaryLabel.length > 3 ? 12 : 17,
                    fontWeight: FontWeight.bold,
                    color: config.textColor,
                  ),
                ),
              ),
            ),
    );

    if (config.swipeUpAction != null) {
      return GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < -200) {
            HapticFeedback.heavyImpact();
            onButtonPressed(config.swipeUpAction!);
          }
        },
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}

class _KeyConfig {
  final String action;
  final String primaryLabel;
  final String? secondaryLabel;
  final Color color;
  final Color textColor;
  final List<Color>? gradient;
  final bool isGlow;
  final VoidCallback haptic;
  final String? swipeUpAction;

  _KeyConfig({
    required this.action,
    required this.primaryLabel,
    this.secondaryLabel,
    required this.color,
    required this.textColor,
    this.gradient,
    this.isGlow = false,
    required this.haptic,
    this.swipeUpAction,
  });
}

class _NeumorphicKeyWrapper extends StatefulWidget {
  final VoidCallback onTap;
  final Color? color;
  final List<Color>? gradient;
  final Widget child;
  final bool isGlow;

  const _NeumorphicKeyWrapper({
    required this.onTap,
    this.color,
    this.gradient,
    required this.child,
    this.isGlow = false,
  });

  @override
  State<_NeumorphicKeyWrapper> createState() => _NeumorphicKeyWrapperState();
}

class _NeumorphicKeyWrapperState extends State<_NeumorphicKeyWrapper> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double scale = _isPressed ? 0.94 : 1.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.diagonal3Values(scale, scale, 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.color : null,
          gradient: widget.gradient != null
              ? LinearGradient(
                  colors: widget.gradient!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: widget.isGlow
              ? Border.all(color: CalculatorTheme.scientificAltText, width: 1.5)
              : Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF050811).withValues(alpha: 0.9),
                    blurRadius: 3,
                    offset: const Offset(1, 1),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0xFF141A30),
                    blurRadius: 5,
                    offset: Offset(-2, -2),
                  ),
                  const BoxShadow(
                    color: Color(0xFF050811),
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                  if (widget.isGlow)
                    BoxShadow(
                      color: CalculatorTheme.scientificAltText.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}
