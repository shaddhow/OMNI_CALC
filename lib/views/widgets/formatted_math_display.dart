import 'package:flutter/material.dart';
import '../../core/calculator_theme.dart';

class FormattedMathDisplay extends StatelessWidget {
  final String expression;
  final TextStyle textStyle;
  final Alignment alignment;

  const FormattedMathDisplay({
    super.key,
    required this.expression,
    required this.textStyle,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    if (expression.isEmpty) {
      return Align(
        alignment: alignment,
        child: Text('0', style: textStyle),
      );
    }

    final inlineSpans = _buildSpans(expression, textStyle);

    return Align(
      alignment: alignment,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: RichText(
          text: TextSpan(children: inlineSpans),
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(String text, TextStyle baseStyle) {
    final List<InlineSpan> spans = [];
    int i = 0;

    while (i < text.length) {
      // Exponents like ^2, ^3, ^(expr), ^x
      if (text[i] == '^') {
        i++;
        String expText = '';
        if (i < text.length && text[i] == '(') {
          int depth = 1;
          i++;
          while (i < text.length && depth > 0) {
            if (text[i] == '(') depth++;
            if (text[i] == ')') depth--;
            if (depth > 0) expText += text[i];
            i++;
          }
        } else if (i < text.length) {
          expText = text[i];
          i++;
        }
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Transform.translate(
              offset: const Offset(0, -6),
              child: Text(
                expText.isEmpty ? '^' : expText,
                style: baseStyle.copyWith(
                  fontSize: (baseStyle.fontSize ?? 18) * 0.7,
                  color: CalculatorTheme.scientificText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        continue;
      }

      // Square roots sqrt(expr) or √(expr)
      if (text.startsWith('sqrt(', i) || text.startsWith('√(', i)) {
        int prefixLen = text.startsWith('sqrt(', i) ? 5 : 2;
        i += prefixLen;
        String inside = '';
        int depth = 1;
        while (i < text.length && depth > 0) {
          if (text[i] == '(') depth++;
          if (text[i] == ')') depth--;
          if (depth > 0) inside += text[i];
          i++;
        }

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: CalculatorTheme.scientificText, width: 1.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '√',
                    style: baseStyle.copyWith(
                      color: CalculatorTheme.scientificText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(inside, style: baseStyle),
                ],
              ),
            ),
          ),
        );
        continue;
      }

      // Superscript digits like ⁻¹, ², ³ or ˣ
      if ('⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺ˣ'.contains(text[i])) {
        spans.add(
          TextSpan(
            text: text[i],
            style: baseStyle.copyWith(
              color: CalculatorTheme.scientificAltText,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        i++;
        continue;
      }

      // Operator highlights
      if ('+×÷-*/='.contains(text[i])) {
        spans.add(
          TextSpan(
            text: text[i] == '*' ? '×' : (text[i] == '/' ? '÷' : text[i]),
            style: baseStyle.copyWith(
              color: CalculatorTheme.operatorText,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        i++;
        continue;
      }

      // Regular characters
      spans.add(TextSpan(text: text[i], style: baseStyle));
      i++;
    }

    return spans;
  }
}
