import 'package:flutter/foundation.dart';

class DebugUtils {
  static void printDebug(String message) {
    // Print messages only in development
    if (!kReleaseMode) {
      print(message);
    }
  }
}
