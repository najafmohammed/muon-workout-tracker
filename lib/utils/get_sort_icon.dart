// Helper method to determine sort icon
import 'package:flutter/material.dart';

IconData getSortIcon(String option) {
  return option.endsWith('_asc') ? Icons.arrow_upward : Icons.arrow_downward;
}
