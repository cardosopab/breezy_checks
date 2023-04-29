import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/check.dart';

class CheckListNotifier extends StateNotifier<List<Check>> {
  late final SharedPreferences _prefs;
  CheckListNotifier(List<Check> checks) : super(checks) {
    _loadChecks();
  }

  static const _kChecksKey = 'checks';

  void addCheck(Check check) {
    state.insert(0, check);
    state = state.toList();
    _saveChecks();
  }

  void deleteCheck(String checkId) {
    state = state.where((check) => check.id != checkId).toList();
    _saveChecks();
  }

  void updateCheck(Check newCheck, String checkId) {
    state = state.map((check) {
      return check.id == checkId ? newCheck : check;
    }).toList();
    _saveChecks();
  }

  void reorderCheckList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final removedItem = state.removeAt(oldIndex);
    state.insert(newIndex, removedItem);
    state = state.toList();
    _saveChecks();
  }

  Future<void> deleteCheckList() async {
    state = [];
    _prefs.remove(_kChecksKey);
  }

  Future<void> _saveChecks() async {
    final checksJson = jsonEncode(state.map((check) => check.toJson()).toList());
    _prefs.setString(_kChecksKey, checksJson);
  }

  Future<void> _loadChecks() async {
    _prefs = await SharedPreferences.getInstance();
    final checksJson = _prefs.getString(_kChecksKey);
    if (checksJson != null) {
      final checksData = jsonDecode(checksJson) as List<dynamic>;
      final checks = checksData.map((data) => Check.fromJson(data)).toList();
      state = checks;
    }
  }
}

final checkStateNotifierProvider = StateNotifierProvider<CheckListNotifier, List<Check>>((ref) {
  return CheckListNotifier([]);
});
