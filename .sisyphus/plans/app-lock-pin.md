# App Lock PIN Feature - Work Plan

## TL;DR

> **Quick Summary**: Add a 4-digit PIN app lock feature that protects the app on launch and when returning from background. PIN is set after login, persists until logout, and can be changed from settings.
> 
> **Deliverables**:
> - PIN storage service with secure local persistence
> - PIN state management via Provider
> - PIN setup screen (set/confirm PIN)
> - PIN verification screen (unlock app)
> - Settings option to change PIN
> - Integration with auth flow (check on launch + background return)
> - Clear PIN on logout
> 
> **Estimated Effort**: Medium
> **Parallel Execution**: YES - 3 waves
> **Critical Path**: Add dependency → PIN service → PIN provider → Auth wrapper integration → Screens

---

## Context

### Original Request
User wants a privacy feature: set app lock with PIN after login, and when logout, the app lock vanishes.

### Interview Summary
**Key Discussions**:
- PIN digits: 4 digits
- When required: App launch + background return
- Persistence: Persist until logout only (clears on logout)
- Change PIN: Yes, add option in settings
- Test approach: TDD with flutter_test

**Research Findings**:
- App uses Firebase Auth (AuthService, AuthWrapper)
- State management: Provider (ChangeNotifier)
- No local storage yet - need shared_preferences
- AuthWrapper is the key integration point

### Metis Review
- Metis consultation timed out - proceeding with clear requirements

---

## Work Objectives

### Core Objective
Implement a 4-digit PIN app lock that:
1. User can set after logging in
2. Prompts for PIN on every app launch
3. Prompts for PIN when returning from background (after ~30 sec)
4. Persists until user logs out (then PIN is cleared)
5. User can change PIN from settings

### Concrete Deliverables
- `lib/services/pin_service.dart` - PIN storage service using shared_preferences
- `lib/providers/pin_provider.dart` - PIN state management
- `lib/screens/pin_setup_screen.dart` - Set/confirm new PIN
- `lib/screens/pin_verification_screen.dart` - Enter PIN to unlock
- Settings update - Add "Change PIN" option
- `lib/screens/auth_wrapper.dart` - Modified to check PIN on launch/background
- `lib/services/auth_service.dart` - Modified to clear PIN on logout

### Definition of Done
- [ ] PIN can be set after login
- [ ] PIN is required on app launch
- [ ] PIN is required when returning from background
- [ ] PIN is cleared on logout
- [ ] PIN can be changed from settings
- [ ] All tests pass

### Must Have
- 4-digit numeric PIN
- PIN verification on app launch
- PIN verification on background return
- Clear PIN on Firebase logout
- Change PIN option in settings

### Must NOT Have (Guardrails)
- No biometric authentication (out of scope)
- No complex PIN encryption (store as hashed)
- No PIN recovery/reset (logout required)
- No guest mode bypass

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (flutter_test in pubspec.yaml)
- **Automated tests**: TDD - Tests first, then implementation
- **Framework**: flutter_test (built-in)

### QA Policy
Every task includes agent-executed QA scenarios verified via:
- Flutter build verification
- Manual interaction scenarios
- Evidence saved to `.sisyphus/evidence/`

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Foundation - can run immediately):
├── Task 1: Add shared_preferences dependency
├── Task 2: Create PIN storage service
├── Task 3: Create PIN state provider
└── Task 4: Add PIN tests (TDD - write first)

Wave 2 (Core Implementation):
├── Task 5: Implement PIN service (TDD - make tests pass)
├── Task 6: Implement PIN provider
├── Task 7: Create PIN setup screen
├── Task 8: Create PIN verification screen
└── Task 9: Update AuthWrapper for PIN check

Wave 3 (Integration & Settings):
├── Task 10: Add "Change PIN" to settings
├── Task 11: Integrate clear PIN on logout
├── Task 12: Background return PIN check
└── Task 13: Final integration tests

Wave FINAL (Verification):
├── Task F1: Plan compliance audit
├── Task F2: Code quality review
├── Task F3: Real manual QA
└── Task F4: Scope fidelity check
```

---

## TODOs

- [ ] 1. Add shared_preferences dependency to pubspec.yaml

  **What to do**: Add `shared_preferences: ^2.2.2` to dependencies in pubspec.yaml, run `flutter pub get` to install dependency, verify dependency is installed without conflicts

  **Must NOT do**: Don't modify any other files during this task

  **Recommended Agent Profile**:
  - **Category**: `quick` - Simple dependency addition
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 1)
  - **Blocks**: Tasks 5, 6 (need dependency)
  - **Blocked By**: None

  **References**: `pubspec.yaml`

  **Acceptance Criteria**:
  - [ ] shared_preferences added to pubspec.yaml
  - [ ] flutter pub get succeeds

  **QA Scenarios**:
  ```
  Scenario: Verify shared_preferences installed
    Tool: Bash
    Steps: Run `flutter pub get`, check output
    Expected Result: Dependency installs without conflicts
    Evidence: .sisyphus/evidence/task-1-pubget.log
  ```

  **Commit**: NO

- [ ] 2. Create PIN storage service (lib/services/pin_service.dart)

  **What to do**: Create `lib/services/pin_service.dart` with methods: savePin(), verifyPin(), hasPin(), clearPin(). Use shared_preferences, store PIN as hashed (SHA-256)

  **Must NOT do**: Don't integrate with auth yet

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 1)
  - **Blocks**: Task 5
  - **Blocked By**: None

  **References**: `lib/services/auth_service.dart`

  **Acceptance Criteria**:
  - [ ] pin_service.dart created
  - [ ] savePin/verifyPin/hasPin/clearPin methods work

  **QA Scenarios**:
  ```
  Scenario: Verify PIN service
    Tool: Bash (flutter test)
    Expected Result: All tests pass
    Evidence: .sisyphus/evidence/task-2-pinservice.log
  ```

  **Commit**: NO

- [ ] 3. Create PIN state provider (lib/providers/pin_provider.dart)

  **What to do**: Create `lib/providers/pin_provider.dart` extending ChangeNotifier. Track isPinSet, isPinVerified, isAppLocked. Provide setPin(), verifyPin(), lockApp(), unlockApp(), clearPin()

  **Must NOT do**: Don't handle background/foreground detection here

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 1)
  - **Blocks**: Tasks 6, 9
  - **Blocked By**: Task 2

  **References**: `lib/services/file_manager_provider.dart`

  **Acceptance Criteria**:
  - [ ] pin_provider.dart created
  - [ ] All methods work

  **QA Scenarios**:
  ```
  Scenario: Verify PIN provider
    Tool: Bash (flutter test)
    Expected Result: Tests pass
    Evidence: .sisyphus/evidence/task-3-pinprovider.log
  ```

  **Commit**: NO

- [ ] 4. Write PIN service tests (TDD - tests first)

  **What to do**: Create `test/pin_service_test.dart` with tests for savePin, verifyPin, hasPin, clearPin. Tests should FAIL initially (RED phase)

  **Must NOT do**: Don't implement actual service yet

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 1)
  - **Blocks**: Task 5
  - **Blocked By**: None

  **References**: `test/widget_test.dart`

  **Acceptance Criteria**:
  - [ ] test/pin_service_test.dart created
  - [ ] Tests fail initially (RED)

  **QA Scenarios**:
  ```
  Scenario: Verify tests fail
    Tool: Bash (flutter test)
    Expected Result: Tests fail with missing implementation
    Evidence: .sisyphus/evidence/task-4-testsfail.log
  ```

  **Commit**: NO

- [ ] 5. Implement PIN service (TDD - make tests pass)

  **What to do**: Implement PinService so tests from Task 4 pass. Use SHA-256 hashing for PIN storage

  **Must NOT do**: Don't add extra features

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 2)
  - **Blocked By**: Task 4

  **Acceptance Criteria**:
  - [ ] Tests pass

  **QA Scenarios**:
  ```
  Scenario: Tests pass
    Tool: Bash (flutter test test/pin_service_test.dart)
    Expected Result: All pass
    Evidence: .sisyphus/evidence/task-5-testspass.log
  ```

  **Commit**: NO

- [ ] 6. Implement PIN provider

  **What to do**: Implement PinProvider with all state and methods. Connect to PinService

  **Must NOT do**: Don't handle background detection

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 2)
  - **Blocked By**: Task 3

  **Acceptance Criteria**:
  - [ ] Provider works correctly

  **QA Scenarios**:
  ```
  Scenario: Provider works
    Tool: Bash (flutter test)
    Expected Result: Tests pass
    Evidence: .sisyphus/evidence/task-6-provider.log
  ```

  **Commit**: NO

- [ ] 7. Create PIN setup screen (lib/screens/pin_setup_screen.dart)

  **What to do**: Create screen where user sets 4-digit PIN with confirmation. Two-step: enter PIN, confirm PIN. Show error if mismatch

  **Must NOT do**: Don't add biometric options

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 2)
  - **Blocked By**: Task 6

  **References**: `lib/screens/login_screen.dart`

  **Acceptance Criteria**:
  - [ ] Screen displays with PIN input
  - [ ] Confirm step validates matching PIN
  - [ ] Saves PIN via PinProvider

  **QA Scenarios**:
  ```
  Scenario: Setup PIN
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-7-setup-build.log
  ```

  **Commit**: NO

- [ ] 8. Create PIN verification screen (lib/screens/pin_verification_screen.dart)

  **What to do**: Create screen where user enters 4-digit PIN to unlock app. Show error for wrong PIN. Clear input on wrong attempt

  **Must NOT do**: Don't show PIN in plain text

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 2)
  - **Blocked By**: Task 6

  **References**: `lib/screens/login_screen.dart`

  **Acceptance Criteria**:
  - [ ] Screen displays with PIN input (dots/masking)
  - [ ] Correct PIN unlocks app
  - [ ] Wrong PIN shows error

  **QA Scenarios**:
  ```
  Scenario: Verify PIN
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-8-verify-build.log
  ```

  **Commit**: NO

- [ ] 9. Update AuthWrapper for PIN check

  **What to do**: Modify `lib/screens/auth_wrapper.dart` to check if PIN is set. If set, show PIN verification before file manager. If not set (first login), prompt to set PIN

  **Must NOT do**: Don't handle background detection here

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 2)
  - **Blocked By**: Tasks 7, 8

  **References**: `lib/screens/auth_wrapper.dart`

  **Acceptance Criteria**:
  - [ ] Shows PIN setup on first login
  - [ ] Shows PIN verification when PIN is set

  **QA Scenarios**:
  ```
  Scenario: Auth flow with PIN
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-9-authwrapper.log
  ```

  **Commit**: NO

- [ ] 10. Add "Change PIN" to settings

  **What to do**: Add "Change PIN" option in file manager screen or create settings. Navigate to PIN setup screen to change existing PIN (require current PIN verification)

  **Must NOT do**: Don't add without verifying current PIN

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 3)
  - **Blocked By**: Task 9

  **Acceptance Criteria**:
  - [ ] Change PIN option visible in settings
  - [ ] Requires current PIN to change

  **QA Scenarios**:
  ```
  Scenario: Change PIN works
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-10-changepin.log
  ```

  **Commit**: NO

- [ ] 11. Integrate clear PIN on logout

  **What to do**: Modify AuthService logout or AuthWrapper to call PinProvider.clearPin() when user logs out

  **Must NOT do**: Don't clear PIN on app crash/force close

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 3)
  - **Blocked By**: Task 9

  **References**: `lib/services/auth_service.dart`

  **Acceptance Criteria**:
  - [ ] PIN cleared when user logs out
  - [ ] Next login requires new PIN setup

  **QA Scenarios**:
  ```
  Scenario: PIN clears on logout
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-11-logout.log
  ```

  **Commit**: NO

- [ ] 12. Background return PIN check

  **What to do**: Add lifecycle observer to detect app going to background and returning. Lock app when returning after ~30 seconds

  **Must NOT do**: Don't lock on quick switches

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: YES (Wave 3)
  - **Blocked By**: Task 9

  **References**: `lib/screens/auth_wrapper.dart`

  **Acceptance Criteria**:
  - [ ] App locks when returning from background after 30s
  - [ ] Doesn't lock on quick app switch

  **QA Scenarios**:
  ```
  Scenario: Background lock works
    Tool: Flutter build
    Expected Result: Builds successfully
    Evidence: .sisyphus/evidence/task-12-background.log
  ```

  **Commit**: NO

- [ ] 13. Final integration tests

  **What to do**: Run all tests, verify integration works end-to-end

  **Must NOT do**: Don't skip any test

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO (Wave 3 - final)
  - **Blocked By**: Tasks 10, 11, 12

  **Acceptance Criteria**:
  - [ ] All tests pass
  - [ ] Full flow works

  **QA Scenarios**:
  ```
  Scenario: Full integration
    Tool: Bash (flutter test)
    Expected Result: All pass
    Evidence: .sisyphus/evidence/task-13-integration.log
  ```

  **Commit**: NO

---

## Final Verification Wave

- [ ] F1. Plan Compliance Audit

  **What to do**: Read plan, verify each Must Have is implemented, each Must NOT Have is absent

  **Recommended Agent Profile**:
  - **Category**: `oracle`
  - **Skills**: []

  **Output**: Must Have [N/N] | Must NOT Have [N/N] | VERDICT

- [ ] F2. Code Quality Review

  **What to do**: Run flutter analyze, check for code issues

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Output**: Analyze [PASS/FAIL] | VERDICT

- [ ] F3. Real Manual QA

  **What to do**: Build and test all flows manually

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: []

  **Output**: Flows [N/N] | VERDICT

- [ ] F4. Scope Fidelity Check

  **What to do**: Verify nothing beyond scope was added

  **Recommended Agent Profile**:
  - **Category**: `deep`
  - **Skills**: []

  **Output**: Scope [CLEAN/N issues] | VERDICT

---

## Commit Strategy

- Combine all tasks into 1-2 commits max

---

## Success Criteria

- [ ] PIN can be set after login
- [ ] PIN required on app launch
- [ ] PIN required when returning from background (after 30s)
- [ ] PIN cleared on logout
- [ ] PIN can be changed from settings
- [ ] All tests pass
- [ ] flutter analyze passes
