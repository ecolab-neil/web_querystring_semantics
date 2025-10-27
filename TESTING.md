# Testing Instructions

## Quick Start

### Terminal 1: Start Flutter App on Port 8080

```bash
cd /Users/warnene/code/web_querystring_semantics
flutter run -d web-server --web-port 8080
```

Keep this running!

### Terminal 2: Run Test #1 (Basic Visibility)

```bash
cd /Users/warnene/code/web_querystring_semantics
maestro test maestro/web_semantics_test.yaml
```

**Expected Result:** ✅ All assertions pass (QueryString Semantics Demo, Query String:, Enable Semantics: visible)

---

## Test #2: Auto-Enabled on Port 1111

### Terminal 1: Stop Port 8080 (Ctrl+C), Start on Port 1111

```bash
flutter run -d web-server --web-port 1111
```

### Terminal 2: Run Auto-Enabled Test

```bash
maestro test maestro/web_semantics_auto_enabled_test.yaml
```

**Expected Result:** 
- ✅ Page loads
- ✅ "Acc On" button is visible (auto-enabled)
- ✅ Navigation buttons visible
- ✅ Can navigate to Page 1 and back

---

## What Each Test Does

### Test 1: `web_semantics_test.yaml` (Port 8080)
- Tests **basic app visibility**
- Port 8080 = Semantics disabled by default
- Simple UI checks

### Test 2: `web_semantics_auto_enabled_test.yaml` (Port 1111)
- Tests **auto-enable functionality**
- Port 1111 = Semantics auto-enabled via JavaScript
- Verifies navigation with accessibility ON

---

## Manual JavaScript Testing

For detailed semantic DOM verification, use the scripts in `27oct_manual_test.md`:

```bash
# Open http://localhost:8080
# Open browser DevTools Console
# Paste the verification script
```

---

## Troubleshooting

### "Maestro not found"
```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### "Port already in use"
Change to a different port in the YAML file or use a different port for Flutter

### "Test fails on assertVisible"
- Make sure app is fully loaded
- Check that Flutter app started without errors
- Try increasing wait times in the YAML
