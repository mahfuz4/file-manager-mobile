# Rename Modal Consistent Buttons Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the Rename modal button layout consistent with the Delete modal by using a 1/3 Cancel and 2/3 Rename button layout.

**Architecture:** We will modify `lib/widgets/rename_bottom_sheet.dart` to wrap the existing rename button in a `Row` alongside a new `SheetSecondaryButton` for the "Cancel" action.

**Tech Stack:** Flutter, Dart

---

### Task 1: Update RenameBottomSheet Buttons

**Files:**
- Modify: `lib/widgets/rename_bottom_sheet.dart`

**Step 1: Replace the single button with a Row of two buttons**

Replace this code in `lib/widgets/rename_bottom_sheet.dart`:

```dart
            SheetPrimaryButton(
              label: 'Rename',
              icon: Icons.drive_file_rename_outline,
              isLoading: _loading,
              onTap: _rename,
            ),
```

With this code:

```dart
            Row(children: [
              Expanded(
                child: SheetSecondaryButton(
                  label: 'Cancel',
                  onTap: () => Navigator.pop(context),
                  disabled: _loading,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SheetPrimaryButton(
                  label: 'Rename',
                  icon: Icons.drive_file_rename_outline,
                  isLoading: _loading,
                  onTap: _rename,
                ),
              ),
            ]),
```

**Step 2: Commit**

```bash
git add lib/widgets/rename_bottom_sheet.dart
git commit -m "style: make rename modal buttons consistent with delete modal"
```
