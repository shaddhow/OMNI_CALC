import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../core/calculator_theme.dart';

class HistorySavedView extends StatelessWidget {
  final List<String> history;
  final List<String> savedFormulas;
  final Map<String, double>? memoryRegisters;
  final ValueChanged<String> onSelectFormula;
  final VoidCallback? onClearHistory;

  const HistorySavedView({
    super.key,
    required this.history,
    required this.savedFormulas,
    this.memoryRegisters,
    required this.onSelectFormula,
    this.onClearHistory,
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
                'HISTORY & MEMORY',
                style: TextStyle(
                  color: CalculatorTheme.scientificText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share, color: CalculatorTheme.scientificText, size: 20),
                    tooltip: 'Share History',
                    onPressed: () {
                      if (history.isNotEmpty) {
                        Share.share(
                          'OMNI_CALC Calculation History:\n\n${history.join("\n")}',
                          subject: 'OMNI_CALC History Export',
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No calculation history to share.')),
                        );
                      }
                    },
                  ),
                  if (onClearHistory != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: CalculatorTheme.utilityText, size: 20),
                      tooltip: 'Clear History',
                      onPressed: () {
                        onClearHistory!();
                        Navigator.of(context).pop();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Memory Registers Section
          if (memoryRegisters != null && memoryRegisters!.isNotEmpty) ...[
            const Text('Variable Memory Registers (A, B, C, D, X, Y, Ans)', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 11)),
            const SizedBox(height: 6),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: memoryRegisters!.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: CalculatorTheme.glassSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: CalculatorTheme.glassBorder),
                    ),
                    child: Row(
                      children: [
                        Text('${entry.key}: ', style: const TextStyle(color: CalculatorTheme.scientificAltText, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(
                          entry.value == entry.value.toInt()
                              ? entry.value.toInt().toString()
                              : entry.value.toStringAsFixed(2),
                          style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Text('Saved Formulas', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 11)),
          const SizedBox(height: 6),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: savedFormulas.length,
              itemBuilder: (context, index) {
                final formula = savedFormulas[index];
                return Card(
                  color: CalculatorTheme.glassSurface,
                  margin: const EdgeInsets.only(bottom: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: CalculatorTheme.glassBorder),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(formula, style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13)),
                    trailing: const Icon(Icons.north_west, color: CalculatorTheme.scientificText, size: 16),
                    onTap: () {
                      onSelectFormula(formula);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text('Recent Calculation History', style: TextStyle(color: CalculatorTheme.textMuted, fontSize: 11)),
          const SizedBox(height: 6),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text('No calculation history yet.', style: TextStyle(color: CalculatorTheme.textMuted)))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return ListTile(
                        dense: true,
                        title: Text(item, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 14)),
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
