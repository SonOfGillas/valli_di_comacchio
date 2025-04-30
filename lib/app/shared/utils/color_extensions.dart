import 'package:flutter/material.dart';

extension ColorX on Color {
  ColorFilter get filterSrcIn {
    return ColorFilter.mode(this, BlendMode.srcIn);
  }
}
