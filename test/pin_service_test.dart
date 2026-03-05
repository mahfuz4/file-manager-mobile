import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FileFort/services/pin_service.dart';

void main() {
  late PinService pinService;

  setUp(() {
    pinService = PinService();
    SharedPreferences.setMockInitialValues({});
  });

  group('PinService', () {
    test('hasPin returns false when no PIN is set', () async {
      expect(await pinService.hasPin(), false);
    });

    test('savePin stores PIN hash', () async {
      await pinService.savePin('1234');
      expect(await pinService.hasPin(), true);
    });

    test('verifyPin returns true for correct PIN', () async {
      await pinService.savePin('1234');
      expect(await pinService.verifyPin('1234'), true);
    });

    test('verifyPin returns false for incorrect PIN', () async {
      await pinService.savePin('1234');
      expect(await pinService.verifyPin('5678'), false);
    });

    test('verifyPin returns false when no PIN is set', () async {
      expect(await pinService.verifyPin('1234'), false);
    });

    test('clearPin removes stored PIN', () async {
      await pinService.savePin('1234');
      await pinService.clearPin();
      expect(await pinService.hasPin(), false);
    });

    test('PIN is stored as hash, not plaintext', () async {
      await pinService.savePin('1234');
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('app_lock_pin_hash');
      expect(stored, isNot('1234'));
      expect(stored, isNotNull);
    });
  });
}
