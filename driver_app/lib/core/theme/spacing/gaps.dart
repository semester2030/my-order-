import 'package:flutter/material.dart';
import 'insets.dart';

/// Gap widgets for spacing between elements
class Gaps {
  Gaps._();

  // Extra Small
  static const Widget xs = SizedBox(height: Insets.xs, width: Insets.xs);
  static const Widget xsH = SizedBox(width: Insets.xs);
  static const Widget xsV = SizedBox(height: Insets.xs);

  // Small
  static const Widget sm = SizedBox(height: Insets.sm, width: Insets.sm);
  static const Widget smH = SizedBox(width: Insets.sm);
  static const Widget smV = SizedBox(height: Insets.sm);

  // Medium
  static const Widget md = SizedBox(height: Insets.md, width: Insets.md);
  static const Widget mdH = SizedBox(width: Insets.md);
  static const Widget mdV = SizedBox(height: Insets.md);

  // Large
  static const Widget lg = SizedBox(height: Insets.lg, width: Insets.lg);
  static const Widget lgH = SizedBox(width: Insets.lg);
  static const Widget lgV = SizedBox(height: Insets.lg);

  // Extra Large
  static const Widget xl = SizedBox(height: Insets.xl, width: Insets.xl);
  static const Widget xlH = SizedBox(width: Insets.xl);
  static const Widget xlV = SizedBox(height: Insets.xl);

  // Extra Extra Large
  static const Widget xxl = SizedBox(height: Insets.xxl, width: Insets.xxl);
  static const Widget xxlH = SizedBox(width: Insets.xxl);
  static const Widget xxlV = SizedBox(height: Insets.xxl);
}
