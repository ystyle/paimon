# Window Immersive & Auto-Rotation Design

## Summary

Add device-aware window management to the Paimon app:
- **PC (2in1)**: Hide system window title bar when entering game (immersive)
- **Mobile (phone/tablet)**: Auto-rotate to landscape when entering game, restore portrait when leaving

## Changes

### File: `entry/src/main/ets/pages/Game.ets`

**`aboutToAppear()`:**
- Existing: `setWindowSystemBarEnable([])` + `setWindowLayoutFullScreen(true)`
- Add: Detect device type via `@ohos.deviceInfo.deviceType`
  - `2in1` → `setWindowSystemTitleBarVisible(false)`
  - `phone`/`tablet` → `setPreferredOrientation(Orientation.LANDSCAPE)`

**`aboutToDisappear()`:** (new block)
- `2in1` → `setWindowSystemTitleBarVisible(true)`
- `phone`/`tablet` → `setPreferredOrientation(Orientation.PORTRAIT)`

### File: `entry/src/main/ets/pages/Index.ets`

**`onPageShow()`:**
- Existing: `setWindowSystemBarEnable(['status', 'navigation'])` + `setWindowLayoutFullScreen(false)`
- Add: Same restoration logic as Game.ets `aboutToDisappear`

### APIs Used

| API | Source |
|-----|--------|
| `deviceInfo.deviceType` | `@ohos.deviceInfo` |
| `setWindowSystemTitleBarVisible()` | `@ohos.window` |
| `setPreferredOrientation()` | `@ohos.window` |
| `Orientation.LANDSCAPE` / `PORTRAIT` / `UNSPECIFIED` | `@ohos.window` |

### Device Mapping

| deviceType | Action on enter game | Action on leave game |
|------------|---------------------|---------------------|
| `2in1` | Hide title bar | Show title bar |
| `phone` / `tablet` | Force landscape | Restore portrait |
| `default` | No change | No change |

## Risk

- `@ohos.deviceInfo` was deprecated in API 12 but still functional in API 17
- `setWindowSystemTitleBarVisible()` may not exist on non-2in1 devices; guard with try-catch
