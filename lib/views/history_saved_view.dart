import 'package:flutter/material.dart';
import '../core/calculator_theme.dart';

class HistorySavedView extends StatelessWidget {
  final List<String> history;
  final List<String> savedFormulas;
  final ValueChanged<String> onSelectFormula;

  const HistorySavedView({
    super.key,
    required this.history,
    required this.savedFormulas,
    required this.onSelectFormula,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CalculatorTheme.background,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HISTORY & SAVED FORMULAS',
                style: TextStyle(
                  color: CalculatorTheme.scientificText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Saved Formulas (omni_calc_math_storage)', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: savedFormulas.length,
              itemBuilder: (context, index) {
                final formula = savedFormulas[index];
                return Card(
                  color: CalculatorTheme.glassSurface,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: CalculatorTheme.glassBorder),
                  ),
                  child: ListTile(
                    title: Text(formula, style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
                    trailing: const Icon(Icons.north_west, color: CalculatorTheme.scientificText, size: 18),
                    onTap: () {
                      onSelectFormula(formula);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Recent Calculation History', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  dense: true,
                  title: Text(item, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 15)),
                  leading: const Icon(Icons.history, color: CalculatorTheme.textMuted, size: 16),
                  onTap: () {
                    onSelectFormula(item.split('=').first.trim());
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
