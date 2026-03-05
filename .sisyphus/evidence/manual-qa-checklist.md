# App Lock PIN - Manual Verification Checklist

## Pre-Flight Checks

### 1. Install Dependencies
```bash
cd /workspaces/file-manager-mobile
flutter pub get
```
Expected: shared_preferences installs without conflicts

### 2. Run Tests
```bash
flutter test test/pin_service_test.dart
```
Expected: All 7 tests pass

### 3. Static Analysis
```bash
flutter analyze
```
Expected: No errors (warnings acceptable)

## User Flow Testing

### Flow 1: First Login (Set PIN)
1. Launch app
2. Login with Firebase credentials
3. **Expected**: Prompted to set 4-digit PIN
4. Enter PIN: 1234
5. **Expected**: Prompted to confirm PIN
6. Enter PIN: 1234
7. **Expected**: Navigates to file manager

### Flow 2: App Launch (Verify PIN)
1. Close app completely
2. Relaunch app
3. **Expected**: Prompted for PIN immediately
4. Enter correct PIN: 1234
5. **Expected**: Unlocks to file manager

### Flow 3: Background Return (30s+ Lock)
1. Open app (unlocked)
2. Press home button (app to background)
3. Wait 35 seconds
4. Return to app
5. **Expected**: Prompted for PIN
6. Enter correct PIN: 1234
7. **Expected**: Unlocks to file manager

### Flow 4: Background Return (Quick Switch)
1. Open app (unlocked)
2. Press home button
3. Wait 10 seconds (less than 30)
4. Return to app
5. **Expected**: No PIN prompt, stays unlocked

### Flow 5: Change PIN
1. In file manager, tap settings icon (gear)
2. Tap "Change PIN"
3. **Expected**: Prompted for current PIN
4. Enter current PIN: 1234
5. **Expected**: Prompted to set new PIN
6. Enter new PIN: 5678
7. **Expected**: Prompted to confirm new PIN
8. Enter new PIN: 5678
9. **Expected**: Success message, returns to file manager
10. Close and relaunch app
11. **Expected**: New PIN (5678) works

### Flow 6: Change PIN - Wrong Current PIN
1. Tap settings → Change PIN
2. Enter wrong current PIN: 9999
3. **Expected**: Error "Incorrect PIN", input clears
4. Can retry with correct PIN

### Flow 7: Set PIN - Mismatch
1. Logout and login again
2. Set PIN: 1234
3. Confirm PIN: 5678 (different)
4. **Expected**: Error "PINs do not match"
5. **Expected**: Returns to first step
6. Can retry with matching PINs

### Flow 8: Logout Clears PIN
1. Login and set PIN: 1234
2. Verify PIN works (close/reopen app)
3. Logout from file manager
4. Login again
5. **Expected**: Prompted to set NEW PIN (old one cleared)

### Flow 9: Wrong PIN on Unlock
1. App locked, prompted for PIN
2. Enter wrong PIN: 9999
3. **Expected**: Error "Incorrect PIN", input clears
4. Can retry unlimited times
5. Enter correct PIN
6. **Expected**: Unlocks successfully

## Edge Cases

### Edge 1: PIN Input Validation
- Only accepts digits (0-9)
- Maximum 4 digits
- Auto-submits when 4 digits entered

### Edge 2: Background Threshold
- 29 seconds in background → No lock
- 31 seconds in background → Lock
- Threshold is 30 seconds

### Edge 3: Multiple Background Cycles
1. Lock/unlock app
2. Background 35s → Lock → Unlock
3. Background 35s again → Lock → Unlock
4. **Expected**: Works consistently

## Security Verification

### Check 1: PIN Storage
```bash
# After setting PIN, check SharedPreferences
# PIN should be stored as hash, not plaintext
# Key: app_lock_pin_hash
# Value: Should be 64-character SHA-256 hash
```

### Check 2: No PIN Bypass
- Cannot access file manager without PIN when locked
- Back button doesn't bypass PIN screen
- App switcher doesn't show sensitive content

## Performance

### Check 1: PIN Check Speed
- PIN verification should be instant (<100ms)
- No noticeable lag when unlocking

### Check 2: Background Detection
- App lifecycle detection works reliably
- No false positives (locking when shouldn't)
- No false negatives (not locking when should)

## UI/UX Verification

### Check 1: Visual Consistency
- PIN screens match app theme (dark, orange accent)
- Input masking (dots) works
- Error messages are clear and visible

### Check 2: Keyboard Behavior
- Numeric keyboard appears automatically
- Keyboard dismisses after submission
- Input clears on error

### Check 3: Navigation
- Can't navigate away from PIN screen when locked
- Settings modal closes properly
- Change PIN flow navigation is smooth

## Regression Testing

### Check 1: Existing Features
- File upload still works
- File download still works
- Folder navigation still works
- Search/filter still works
- Bulk actions still work

### Check 2: Auth Flow
- Login still works
- Logout still works
- Auth state changes handled correctly

## Sign-Off

- [ ] All pre-flight checks pass
- [ ] All user flows work as expected
- [ ] All edge cases handled
- [ ] Security verified
- [ ] Performance acceptable
- [ ] UI/UX consistent
- [ ] No regressions

**Tester**: _______________
**Date**: _______________
**Build**: _______________
**Device**: _______________
**Notes**: _______________
