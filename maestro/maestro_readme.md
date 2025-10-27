# Maestro Tests for Flutter Web Semantics

This directory contains Maestro test flows for verifying Flutter web accessibility/semantics functionality.

## Prerequisites

### Install Maestro

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

Or see [Installation Guide](https://docs.maestro.dev/getting-started/installing-maestro).

### Start Flutter Web App

The tests expect the Flutter web app to be running on `http://localhost:8080`.

```bash
flutter run -d web-server --web-port 8080
```

Keep this running in a separate terminal.

## Test Files

### Port Configuration

Based on the configuration in `web/index.html`:

- **Port 8080** (Development): Semantics disabled by default, requires manual click
  - Use for testing the invisible button click functionality
  - Tests `web_semantics_test.yaml`
  
- **Port 1111** (Demo/QA): Semantics auto-enabled via JavaScript
  - Use for testing app with accessibility always on
  - Tests `web_semantics_auto_enabled_test.yaml`
  - Perfect for QA/demo environments where accessibility should "just work"
  
- **Port 0000** (Disabled Testing): Semantics explicitly disabled
  - Use for testing disabled state
  - Currently no dedicated test, but available for manual testing

### `web_semantics_test.yaml` (Port 8080)

Tests the Flutter invisible accessibility button functionality.

**What it tests:**
1. Semantics are initially disabled (minimal accessibility)
2. Navigation buttons are NOT accessible to screen readers initially
3. The invisible `flt-semantics-placeholder` button can be found and clicked
4. After clicking, semantics are enabled (rich accessibility with proper ARIA roles)
5. UI elements like "Acc On" and navigation buttons become accessible

**Run with:**
```bash
# Start on port 8080 (default)
flutter run -d web-server --web-port 8080

# Run test
maestro test maestro/web_semantics_test.yaml
```

### `web_semantics_auto_enabled_test.yaml` (Port 1111)

Tests that semantics are automatically enabled on the demo/QA port.

**What it tests:**
1. Semantics are enabled immediately when page loads (auto-click via JavaScript)
2. Navigation buttons ARE accessible right away
3. Semantics count is high (>10 semantic elements, >3 buttons)
4. Navigation between pages works with semantics enabled
5. State persists across navigation

**Use case:** This is for demo/QA environments where you want accessibility working without manual steps.

**Run with:**
```bash
# Start on port 1111
flutter run -d web-server --web-port 1111

# Run test  
maestro test maestro/web_semantics_auto_enabled_test.yaml
```

**Reference:** [Flutter Web Accessibility Docs](https://docs.flutter.dev/ui/accessibility/web-accessibility#invisible-button)

## Running Tests

### Run a Single Test

```bash
# From project root
maestro test maestro/web_semantics_test.yaml

# Or from maestro directory
cd maestro
maestro test web_semantics_test.yaml
```

### Run All Tests

```bash
maestro test maestro/
```

### With Cloud Recording (for debugging)

```bash
maestro test maestro/web_semantics_test.yaml --format junit
```

### With Live View

```bash
maestro test maestro/web_semantics_test.yaml --debug
```

## Understanding the Test

### Before Clicking

The app should have minimal accessibility:
- Very few `<flt-semantics>` elements (0-5)
- No semantic button roles
- Screen readers can't navigate properly

### After Clicking

The invisible button enables semantics:
- Many `<flt-semantics>` elements (10+)
- Proper button roles and ARIA labels
- Screen readers can navigate and announce content

### How It Works

1. **Find the invisible button**: `document.querySelector('flt-semantics-placeholder[aria-label="Enable accessibility"]')`
2. **Click it**: `invisibleButton.click()`
3. **Flutter activates semantics**: `SemanticsBinding.instance.ensureSemantics()` is called internally
4. **DOM updates**: Flutter generates semantic HTML elements

## Test Output

Expected output when running:

```
✅ Verified: Semantics absent before clicking invisible button
✅ Found invisible button, clicking...
✅ Click successful
✅ Verified: Semantics present after clicking invisible button
✅ Test PASSED: Accessibility toggle working correctly
```

## Troubleshooting

### "Invisible button not found"

- Ensure Flutter app is running on port 8080
- Check that the page has fully loaded (use `waitForVisible` command)
- Verify Flutter web accessibility is supported in your build

### "Semantics should be disabled but found too many elements"

- The app may have been started with semantics already enabled
- Stop and restart the app: `flutter run -d web-server --web-port 8080`

### "Expected at least X semantic elements, found Y"

- Semantics may not have activated properly
- Increase the wait time after clicking: change `wait: 500` to `wait: 1000`
- Check browser console for JavaScript errors

## Advanced Usage

### Custom Port

To test on a different port, modify the `url` in the YAML file:

```yaml
url: http://localhost:7777
```

### Parameters

Pass environment variables:

```bash
maestro test web_semantics_test.yaml \
  -e PORT=7777 \
  -e MIN_SEMANTICS=10
```

Then use in script:
```javascript
const port = env.PORT || '8080';
const url = `http://localhost:${port}`;
```

## Maestro Resources

- [Getting Started](https://docs.maestro.dev/getting-started/writing-your-first-flow)
- [Web Support](https://docs.maestro.dev/platform-support/web-desktop-browser)
- [JavaScript Support](https://docs.maestro.dev/advanced/javascript/run-javascript)
- [Command Reference](https://docs.maestro.dev/api-reference/commands)
