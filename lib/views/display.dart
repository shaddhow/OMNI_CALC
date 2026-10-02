import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/calculator_theme.dart';
import '../core/math_parser.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;
  final AngleUnit angleUnit;
  final bool isHyp;
  final List<String> historyTape;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
    required this.angleUnit,
    required this.isHyp,
    required this.historyTape,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 300) {
            onSwipeRight(); // Swipe right -> history / saved functions
          } else if (details.primaryVelocity! < -300) {
            onSwipeLeft(); // Swipe left -> undo
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: CalculatorTheme.glassSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: CalculatorTheme.glassBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row: Mode chips (DEG, HYP) pinned left, status muted right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildBadge(angleUnit == AngleUnit.deg ? 'DEG' : 'RAD', true),
                          const SizedBox(width: 8),
                          _buildBadge('HYP', isHyp),
                        ],
                      ),
                      const Text(
                        'FX-991ES • OMNI',
                        style: TextStyle(
                          color: CalculatorTheme.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Middle Row: History expression right-aligned with subtle text opacity
                  SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: historyTape.isEmpty
                          ? Text(
                              'READY',
                              style: TextStyle(
                                color: CalculatorTheme.textMuted.withValues(alpha: 0.35),
                                fontSize: 11,
                                fontFamily: 'monospace',
                                letterSpacing: 1.0,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: historyTape.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    historyTape[index],
                                    style: TextStyle(
                                      color: CalculatorTheme.textMuted.withValues(
                                        alpha: (0.75 - (index * 0.15)).clamp(0.2, 0.75),
                                      ),
                                      fontSize: 13,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: CalculatorTheme.glassBorder, height: 1),
                  const SizedBox(height: 6),

                  // Bottom Row: Main input & result right-aligned with dynamic scaling (FittedBox)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            expression.isEmpty ? '0' : expression,
                            style: const TextStyle(
                              color: CalculatorTheme.textMuted,
                              fontSize: 18,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            result.isEmpty ? (expression.isEmpty ? '0' : expression) : result,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? CalculatorTheme.scientificText.withValues(alpha: 0.2) : CalculatorTheme.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? CalculatorTheme.scientificText : CalculatorTheme.glassBorder,
          width: isActive ? 1.2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? CalculatorTheme.scientificText : CalculatorTheme.textMuted,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
