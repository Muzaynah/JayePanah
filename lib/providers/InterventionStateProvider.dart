import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SelfRegulationPhase {
  stabilization,
  breathing,
  grounding,
  reassurance,
  recovery,
}

enum HelperGuidanceScreen {
  immediateResponse,
  communication,
  breathingSync,
  environmental,
  assessment,
  escalation,
}

class InterventionStateProvider extends ChangeNotifier {
  SelfRegulationPhase? _selfRegulationPhase;
  HelperGuidanceScreen? _helperScreen;
  int _groundingStep = 0;
  int _reassuranceStep = 0;
  bool _isBreathingPaused = false;
  DateTime? _sessionStartTime;
  String? _recoveryResponse;

  static const String _phaseKey = 'jayepanah_phase';
  static const String _helperScreenKey = 'jayepanah_helper_screen';
  static const String _groundingStepKey = 'jayepanah_grounding_step';
  static const String _reassuranceStepKey = 'jayepanah_reassurance_step';
  static const String _sessionStartKey = 'jayepanah_session_start';

  InterventionStateProvider() {
    _loadState();
  }

  SelfRegulationPhase? get selfRegulationPhase => _selfRegulationPhase;
  HelperGuidanceScreen? get helperScreen => _helperScreen;
  int get groundingStep => _groundingStep;
  int get reassuranceStep => _reassuranceStep;
  bool get isBreathingPaused => _isBreathingPaused;
  DateTime? get sessionStartTime => _sessionStartTime;
  String? get recoveryResponse => _recoveryResponse;

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final phaseIndex = prefs.getInt(_phaseKey);
    final helperScreenIndex = prefs.getInt(_helperScreenKey);
    final sessionStartMillis = prefs.getInt(_sessionStartKey);

    if (phaseIndex != null && phaseIndex < SelfRegulationPhase.values.length) {
      _selfRegulationPhase = SelfRegulationPhase.values[phaseIndex];
    }
    if (helperScreenIndex != null && helperScreenIndex < HelperGuidanceScreen.values.length) {
      _helperScreen = HelperGuidanceScreen.values[helperScreenIndex];
    }
    _groundingStep = prefs.getInt(_groundingStepKey) ?? 0;
    _reassuranceStep = prefs.getInt(_reassuranceStepKey) ?? 0;
    if (sessionStartMillis != null) {
      _sessionStartTime = DateTime.fromMillisecondsSinceEpoch(sessionStartMillis);
    }
    notifyListeners();
  }

  Future<void> startSelfRegulation() async {
    _selfRegulationPhase = SelfRegulationPhase.stabilization;
    _sessionStartTime = DateTime.now();
    await saveState();
    notifyListeners();
  }

  Future<void> setSelfRegulationPhase(SelfRegulationPhase phase) async {
    _selfRegulationPhase = phase;
    await saveState();
    notifyListeners();
  }

  Future<void> setHelperScreen(HelperGuidanceScreen screen) async {
    _helperScreen = screen;
    await saveState();
    notifyListeners();
  }

  Future<void> setGroundingStep(int step) async {
    _groundingStep = step;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_groundingStepKey, step);
    notifyListeners();
  }

  Future<void> setReassuranceStep(int step) async {
    _reassuranceStep = step;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reassuranceStepKey, step);
    notifyListeners();
  }

  void setBreathingPaused(bool paused) {
    _isBreathingPaused = paused;
    notifyListeners();
  }

  Future<void> setRecoveryResponse(String response) async {
    _recoveryResponse = response;
    notifyListeners();
  }

  Future<void> resetIntervention() async {
    _selfRegulationPhase = null;
    _helperScreen = null;
    _groundingStep = 0;
    _reassuranceStep = 0;
    _isBreathingPaused = false;
    _sessionStartTime = null;
    _recoveryResponse = null;
    await saveState();
    notifyListeners();
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selfRegulationPhase != null) {
      await prefs.setInt(_phaseKey, _selfRegulationPhase!.index);
    } else {
      await prefs.remove(_phaseKey);
    }
    if (_helperScreen != null) {
      await prefs.setInt(_helperScreenKey, _helperScreen!.index);
    } else {
      await prefs.remove(_helperScreenKey);
    }
    await prefs.setInt(_groundingStepKey, _groundingStep);
    await prefs.setInt(_reassuranceStepKey, _reassuranceStep);
    if (_sessionStartTime != null) {
      await prefs.setInt(_sessionStartKey, _sessionStartTime!.millisecondsSinceEpoch);
    } else {
      await prefs.remove(_sessionStartKey);
    }
  }
}
