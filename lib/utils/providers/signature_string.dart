import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final signatureStateProvider = StateProvider<String>((ref) {
  return '';
});

class StringNotifier extends StateNotifier<String> {
  late final SharedPreferences _prefs;
  StringNotifier(String signature) : super(signature) {
    _loadSignature();
  }

  static const _kSignatureKey = 'signatureKey';

  void saveSignature(String newValue) {
    state = newValue;
    _prefs.setString(_kSignatureKey, newValue);
  }

  Future<void> _loadSignature() async {
    _prefs = await SharedPreferences.getInstance();
    final signatureString = _prefs.getString(_kSignatureKey);
    if (signatureString != null) {
      state = signatureString;
    } else {
      _prefs.setString(_kSignatureKey, '');
    }
  }
}

final signatureStateNotifier = StateNotifierProvider<StringNotifier, String>((ref) {
  return StringNotifier('');
});
