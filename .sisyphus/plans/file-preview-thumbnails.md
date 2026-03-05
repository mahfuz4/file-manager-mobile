# File Preview & Thumbnails Implementation

## TL;DR

> **Quick Summary**: Add thumbnails for images/videos/PDFs in file list, in-app preview with zoom/pan for images, PDF rendering, video playback, and full-screen carousel gallery view.
> 
> **Deliverables**:
> - Thumbnail display in file list (images, videos, PDFs)
> - Preview screen with type-specific viewers
> - Full-screen carousel gallery for media browsing
> 
> **Estimated Effort**: Medium
> **Parallel Execution**: YES - 3 waves
> **Critical Path**: Package deps → Model/Service → UI Components → Integration

---

## Context

### Original Request
User wants to add file preview and thumbnails to FileFort Flutter app:
- Thumbnails in file list for images, videos, PDFs
- In-app preview for images (zoom/pan), PDFs (render), videos (playback)
- Carousel gallery view for media browsing

### Interview Summary
**Key Discussions**:
- Thumbnail scope: Images (jpg, png, gif, webp, svg), Videos (mp4, mov, avi, mkv, webm), PDFs
- Preview scope: Images with zoom/pan, PDFs with page rendering, Videos with inline playback
- Gallery: Full-screen swipeable carousel supporting images + videos
- Testing: QA scenarios only

**Research Findings**:
- FileItem model already has FileType enum with image, video, document detection
- FileItemTile shows 36x36 colored icon based on file type
- R2Service.generatePresignedUrl() available for preview URLs
- Current packages: flutter, firebase, http, crypto, xml, provider, google_fonts, shimmer, etc.

---

## Work Objectives

### Core Objective
Add rich media preview capabilities to FileFort: thumbnail previews in file list, in-app viewers for images/PDFs/videos, and carousel gallery navigation.

### Concrete Deliverables
1. Add required packages to pubspec.yaml
2. Create thumbnail service for generating/fetching thumbnails
3. Modify FileItemTile to display thumbnails for supported types
4. Create FilePreviewScreen with image/PDF/video viewers
5. Create CarouselGalleryScreen for swipeable media browsing
6. Wire up navigation from file list to preview/gallery
7. Ensure dark theme consistency throughout

### Definition of Done
- [ ] Images show thumbnails in list (jpg, png, gif, webp)
- [ ] Videos show thumbnail preview in list
- [ ] PDFs show document icon thumbnail in list
- [ ] Tap image → fullscreen preview with zoom/pan
- [ ] Tap PDF → preview with page navigation
- [ ] Tap video → inline playback
- [ ] Gallery button opens carousel with swipe navigation
- [ ] All UI matches dark orange theme

### Must Have
- Thumbnail caching via cached_network_image
- Image zoom/pan via photo_view
- PDF rendering via pdfx
- Video playback via video_player + chewie
- Consistent dark theme styling

### Must NOT Have (Guardrails)
- No light theme changes
- No changes to existing auth flow
- No backend changes (R2 only)
- No unrelated UI modifications

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (basic widget_test.dart)
- **Automated tests**: NO - QA scenarios only
- **Framework**: N/A

### QA Policy
Every task includes agent-executed QA scenarios. All verification via:
- **Flutter build**: Verify compilation succeeds
- **Code inspection**: Verify imports, widget structure
- **Theme check**: Verify dark theme consistency

---

## Execution Strategy

### Parallel Execution Waves

Wave 1 (Foundation - can run parallel):
- Task 1: Add dependencies to pubspec.yaml
- Task 2: Create thumbnail service (r2_thumbnail_service.dart)
- Task 3: Create preview screen scaffold + routing

Wave 2 (Core components - max parallel):
- Task 4: Modify FileItemTile for thumbnails
- Task 5: Create image preview with photo_view
- Task 6: Create PDF preview with pdfx
- Task 7: Create video preview with chewie

Wave 3 (Integration + Gallery):
- Task 8: Wire preview screen navigation
- Task 9: Create carousel gallery widget
- Task 10: Final integration and theme check

---

## TODOs

- [ ] 1. Add package dependencies

  **What to do**:
  - Add `cached_network_image: ^3.3.1` for thumbnail caching
  - Add `photo_view: ^0.15.0` for image zoom/pan
  - Add `pdfx: ^2.6.0` for PDF rendering
  - Add `video_player: ^2.8.6` for video playback
  - Add `chewie: ^1.7.5` for video UI controls

  **Must NOT do**:
  - Don't modify existing package versions
  - Don't add unrelated packages

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple pubspec.yaml edit, no complex logic
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed for dependency addition

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3)
  - **Blocks**: Tasks 4, 5, 6, 7, 8, 9, 10
  - **Blocked By**: None

  **References**:
  - `pubspec.yaml` - Current dependencies
  - `lib/services/r2_service.dart` - Existing service patterns

  **Acceptance Criteria**:
  - [ ] pubspec.yaml updated with new packages
  - [ ] flutter pub get succeeds

  **QA Scenarios**:
  - Scenario: Verify pubspec.yaml has new dependencies
    Tool: Bash
    Steps:
      1. Run `grep -E "cached_network_image|photo_view|pdfx|video_player|chewie" pubspec.yaml`
    Expected Result: All 5 packages listed with version numbers
    Evidence: terminal output showing packages

- [ ] 2. Create thumbnail service

  **What to do**:
  - Create `lib/services/r2_thumbnail_service.dart`
  - Reuse R2Service.generatePresignedUrl() for thumbnail URLs
  - Add method to get preview URL for any file
  - Add thumbnail dimension constants

  **Must NOT do**:
  - Don't modify existing R2Service

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple service class following existing patterns
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 3)
  - **Blocks**: Tasks 4, 5, 6, 7, 8, 9
  - **Blocked By**: None

  **References**:
  - `lib/services/r2_service.dart:208-251` - generatePresignedUrl pattern

  **Acceptance Criteria**:
  - [ ] r2_thumbnail_service.dart created
  - [ ] getThumbnailUrl() method working
  - [ ] getPreviewUrl() method working

  **QA Scenarios**:
  - Scenario: Verify service file exists and compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/services/r2_thumbnail_service.dart`
    Expected Result: No errors
    Evidence: analyze output

- [ ] 3. Create preview screen scaffold + routing

  **What to do**:
  - Create `lib/screens/file_preview_screen.dart`
  - Create route based on file type
  - Add basic scaffold with dark theme
  - Create `lib/screens/carousel_gallery_screen.dart` scaffold

  **Must NOT do**:
  - Don't implement full viewers yet (Tasks 5-7)

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Screen scaffold with theme integration
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2)
  - **Blocks**: Tasks 5, 6, 7, 8, 9
  - **Blocked By**: None

  **References**:
  - `lib/screens/file_manager_screen.dart` - Existing screen patterns
  - `lib/theme/app_theme.dart` - Theme constants

  **Acceptance Criteria**:
  - [ ] file_preview_screen.dart created
  - [ ] carousel_gallery_screen.dart created
  - [ ] Dark theme applied

  **QA Scenarios**:
  - Scenario: Verify screens compile
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/screens/file_preview_screen.dart lib/screens/carousel_gallery_screen.dart`
    Expected Result: No errors
    Evidence: analyze output

- [ ] 4. Modify FileItemTile for thumbnails

  **What to do**:
  - Update `lib/widgets/file_item_tile.dart`
  - Add thumbnail display for images (using CachedNetworkImage)
  - Add thumbnail placeholder for videos
  - Add PDF icon with thumbnail styling
  - Use R2ThumbnailService for URLs

  **Must NOT do**:
  - Don't break existing functionality
  - Don't change selection behavior

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Widget modification with image handling
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 5, 6, 7)
  - **Blocks**: Task 8
  - **Blocked By**: Task 2 (thumbnail service)

  **References**:
  - `lib/widgets/file_item_tile.dart` - Current implementation
  - `lib/models/file_item.dart` - FileType enum

  **Acceptance Criteria**:
  - [ ] Images show CachedNetworkImage thumbnail
  - [ ] Videos show thumbnail preview
  - [ ] PDFs show styled icon
  - [ ] Existing actions still work

  **QA Scenarios**:
  - Scenario: Verify FileItemTile compiles with new code
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/widgets/file_item_tile.dart`
    Expected Result: No errors
    Evidence: analyze output

- [ ] 5. Create image preview with photo_view

  **What to do**:
  - Implement image preview in FilePreviewScreen
  - Use PhotoView for zoom/pan
  - Add loading indicator
  - Add close button
  - Support swipe between images

  **Must NOT do**:
  - Don't add video or PDF code here

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Image viewer with zoom/pan interactions
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 4, 6, 7)
  - **Blocks**: Task 8
  - **Blocked By**: Task 3 (screen scaffold)

  **References**:
  - `lib/screens/file_preview_screen.dart` - Screen to extend
  - `lib/services/r2_thumbnail_service.dart` - URL service

  **Acceptance Criteria**:
  - [ ] Image loads from presigned URL
  - [ ] Pinch to zoom works
  - [ ] Pan works
  - [ ] Close button returns to file list

  **QA Scenarios**:
  - Scenario: Verify image preview compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/screens/file_preview_screen.dart`
    Expected Result: No errors related to photo_view
    Evidence: analyze output

- [ ] 6. Create PDF preview with pdfx

  **What to do**:
  - Add PDF viewer to FilePreviewScreen
  - Use Pdfx for rendering
  - Add page navigation (prev/next)
  - Show page indicator
  - Add loading state

  **Must NOT do**:
  - Don't modify image preview code

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: PDF rendering component
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 4, 5, 7)
  - **Blocks**: Task 8
  - **Blocked By**: Task 3 (screen scaffold)

  **References**:
  - `lib/screens/file_preview_screen.dart` - Screen to extend

  **Acceptance Criteria**:
  - [ ] PDF loads and renders
  - [ ] Page navigation works
  - [ ] Page indicator shows current page

  **QA Scenarios**:
  - Scenario: Verify PDF preview compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/screens/file_preview_screen.dart`
    Expected Result: No errors related to pdfx
    Evidence: analyze output

- [ ] 7. Create video preview with chewie

  **What to do**:
  - Add video player to FilePreviewScreen
  - Use video_player + chewie for controls
  - Add play/pause, seek, fullscreen
  - Handle loading state

  **Must NOT do**:
  - Don't modify image or PDF code

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Video playback component
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 4, 5, 6)
  - **Blocks**: Task 8
  - **Blocked By**: Task 3 (screen scaffold)

  **References**:
  - `lib/screens/file_preview_screen.dart` - Screen to extend

  **Acceptance Criteria**:
  - [ ] Video loads from presigned URL
  - [ ] Play/pause works
  - [ ] Seek works
  - [ ] Controls display properly

  **QA Scenarios**:
  - Scenario: Verify video preview compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/screens/file_preview_screen.dart`
    Expected Result: No errors related to video_player/chewie
    Evidence: analyze output

- [ ] 8. Wire preview screen navigation

  **What to do**:
  - Update FileItemTile onAction to open preview
  - Add 'preview' action to action buttons
  - Pass file to preview screen
  - Handle file type routing

  **Must NOT do**:
  - Don't break existing actions (rename, share, download, delete)

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Navigation wiring
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 9, 10)
  - **Blocks**: None
  - **Blocked By**: Tasks 4, 5, 6, 7

  **References**:
  - `lib/widgets/file_item_tile.dart` - Actions already exist
  - `lib/screens/file_manager_screen.dart` - Navigation pattern

  **Acceptance Criteria**:
  - [ ] Tap preview action opens FilePreviewScreen
  - [ ] Correct viewer shows based on file type
  - [ ] Back navigation works

  **QA Scenarios**:
  - Scenario: Verify navigation compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/`
    Expected Result: No navigation-related errors
    Evidence: analyze output

- [ ] 9. Create carousel gallery widget

  **What to do**:
  - Implement full-screen carousel in CarouselGalleryScreen
  - Use PageView for swipe navigation
  - Support images and videos
  - Add page indicator dots
  - Add close button

  **Must NOT do**:
  - Don't break preview screen functionality

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Carousel UI component
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 8, 10)
  - **Blocks**: None
  - **Blocked By**: Task 3 (screen scaffold), Task 7 (video preview)

  **References**:
  - `lib/screens/carousel_gallery_screen.dart` - Scaffold from Task 3

  **Acceptance Criteria**:
  - [ ] Swipe left/right navigates between media
  - [ ] Page dots show current position
  - [ ] Close returns to file list

  **QA Scenarios**:
  - Scenario: Verify carousel compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/screens/carousel_gallery_screen.dart`
    Expected Result: No errors
    Evidence: analyze output

- [ ] 10. Final integration and theme check

  **What to do**:
  - Add gallery button to toolbar or header
  - Wire gallery button to CarouselGalleryScreen
  - Verify all dark theme colors consistent
  - Test full user flow

  **Must NOT do**:
  - Don't add features outside scope

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
    - Reason: Integration and theme verification
  - **Skills**: []
  - **Skills Evaluated but Omitted**:
    - None needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Tasks 8, 9)
  - **Blocks**: None
  - **Blocked By**: Tasks 8, 9

  **References**:
  - `lib/widgets/toolbar.dart` - Where to add gallery button
  - `lib/theme/app_theme.dart` - Theme constants

  **Acceptance Criteria**:
  - [ ] Gallery button visible in UI
  - [ ] Full flow works: list → preview → close
  - [ ] Full flow works: list → gallery → close
  - [ ] Dark theme consistent throughout

  **QA Scenarios**:
  - Scenario: Verify complete app compiles
    Tool: Bash
    Steps:
      1. Run `flutter analyze lib/`
    Expected Result: 0 errors
    Evidence: analyze output
  - Scenario: Verify APK builds
    Tool: Bash
    Steps:
      1. Run `flutter build apk --debug 2>&1 | tail -20`
    Expected Result: Build succeeded
    Evidence: build output

---

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** 
  Verify all Must Have items implemented: thumbnails in list, preview screen, carousel gallery. Check Must NOT Have items absent: no light theme, no auth changes, no backend changes.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Run `flutter analyze`. Check for: any warnings, unused imports, missing null checks.
  Output: `Analyze [PASS/FAIL] | Issues [N] | VERDICT`

- [ ] F3. **Build Verification** — `unspecified-high`
  Run `flutter build apk --debug`. Verify APK generates successfully.
  Output: `Build [SUCCESS/FAIL] | VERDICT`

- [ ] F4. **Theme Consistency** — `deep`
  Verify all new UI components use AppColors correctly. Check dark theme throughout.
  Output: `Theme [CONSISTENT/ISSUES] | VERDICT`

---

## Commit Strategy

- **1**: `feat(preview): add thumbnail service and file preview screens` - lib/services/r2_thumbnail_service.dart, lib/screens/file_preview_screen.dart, lib/screens/carousel_gallery_screen.dart
- **2**: `feat(ui): add thumbnails to file list items` - lib/widgets/file_item_tile.dart

---

## Success Criteria

### Verification Commands
```bash
flutter analyze lib/           # Expected: 0 errors
flutter build apk --debug     # Expected: BUILD SUCCESSFUL
```

### Final Checklist
- [ ] All "Must Have" present
- [ ] All "Must NOT Have" absent
- [ ] Thumbnails display in file list (images, videos, PDFs)
- [ ] Image preview with zoom/pan works
- [ ] PDF preview with page navigation works
- [ ] Video preview with playback works
- [ ] Carousel gallery swipes between media
- [ ] Dark theme consistent throughout
