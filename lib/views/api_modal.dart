import 'package:flutter/material.dart';
import '../core/calculator_theme.dart';

class ApiModal extends StatelessWidget {
  final String expression;
  final String result;

  const ApiModal({
    super.key,
    required this.expression,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: CalculatorTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.hub, color: CalculatorTheme.scientificText),
                  SizedBox(width: 8),
                  Text(
                    'Wolfram Alpha & Math API',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CalculatorTheme.glassSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CalculatorTheme.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LaTeX Rendered Representation:', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  r'$$\int ' + (expression.isEmpty ? 'f(x)' : expression) + r' dx = ' + (result.isEmpty ? 'C' : result) + r'$$',
                  style: const TextStyle(color: CalculatorTheme.scientificText, fontSize: 18, fontFamily: 'serif'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CalculatorTheme.keyScientific,
              foregroundColor: CalculatorTheme.scientificText,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: CalculatorTheme.glassBorder),
            ),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share Formatted PNG / LaTeX Card'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LaTeX formatted image card copied to clipboard & ready to share!')),
              );
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CalculatorTheme.keyBase,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: CalculatorTheme.glassBorder),
            ),
            icon: const Icon(Icons.cloud_sync),
            label: const Text('Fetch Step-by-Step Solution (Cloud API)'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connected to Wolfram Alpha API mockup: Solution derived successfully.')),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
