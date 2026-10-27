import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Haptics {
  Haptics._();

  static const String _prefKey = 'haptics_enabled';
  static const MethodChannel _channel = MethodChannel('ru.komet.app/haptics');

  static bool enabled = true;

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      enabled = prefs.getBool(_prefKey) ?? true;
    } catch (_) {
      enabled = true;
    }
  }

  static Future<void> setEnabled(bool value) async {
    enabled = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, value);
    } catch (_) {}
  }

  static Future<void> _invoke(String method, Future<void> Function() fallback) async {
    if (!enabled) return;
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _channel.invokeMethod(method);
      } else {
        await fallback();
      }
    } catch (_) {
      try {
        await fallback();
      } catch (_) {}
    }
  }

  static Future<void> tap() => _invoke('light', HapticFeedback.lightImpact);

  static Future<void> soft() => _invoke('soft', HapticFeedback.lightImpact);

  static Future<void> rigid() => _invoke('rigid', HapticFeedback.mediumImpact);

  static Future<void> medium() => _invoke('medium', HapticFeedback.mediumImpact);

  static Future<void> heavy() => _invoke('heavy', HapticFeedback.heavyImpact);

  static Future<void> selection() => _invoke('selection', HapticFeedback.selectionClick);

  static Future<void> send() => tap();

  static Future<void> success() => _invoke('success', () async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 90));
    await HapticFeedback.mediumImpact();
  });

  static Future<void> warning() => _invoke('warning', HapticFeedback.mediumImpact);

  static Future<void> error() => _invoke('error', () async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.heavyImpact();
  });
}
