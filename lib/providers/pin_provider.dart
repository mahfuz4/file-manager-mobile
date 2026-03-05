import 'package:flutter/foundation.dart';
import '../services/pin_service.dart';

class PinProvider extends ChangeNotifier {
  final PinService _pinService = PinService();

  bool _isPinSet = false;
  bool _isPinVerified = false;
  bool _isAppLocked = false;

  bool get isPinSet => _isPinSet;
  bool get isPinVerified => _isPinVerified;
  bool get isAppLocked => _isAppLocked;

  Future<void> init() async {
    _isPinSet = await _pinService.hasPin();
    _isAppLocked = _isPinSet;
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    await _pinService.savePin(pin);
    _isPinSet = true;
    _isPinVerified = true;
    _isAppLocked = false;
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    final valid = await _pinService.verifyPin(pin);
    if (valid) {
      _isPinVerified = true;
      _isAppLocked = false;
      notifyListeners();
    }
    return valid;
  }

  void lockApp() {
    if (_isPinSet) {
      _isAppLocked = true;
      _isPinVerified = false;
      notifyListeners();
    }
  }

  void unlockApp() {
    _isAppLocked = false;
    _isPinVerified = true;
    notifyListeners();
  }

  Future<void> clearPin() async {
    await _pinService.clearPin();
    _isPinSet = false;
    _isPinVerified = false;
    _isAppLocked = false;
    notifyListeners();
  }
}
