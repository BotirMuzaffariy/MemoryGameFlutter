import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }

  MediaQueryData get mediaQuery {
    return MediaQuery.of(this);
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }
}
