# Manual Test Instructions - October 27, 2024

## Overview

This document focuses on verifying that the **actual semantic HTML DOM elements** are present when semantics are enabled. The key test is: **Can a screen reader actually read the buttons and content?**

## Test Environment Setup

### Prerequisites
- Flutter web app running
- Chrome browser with DevTools
- Optionally: VoiceOver (Mac) for screen reader testing

### Start the App
```bash
flutter run -d web-server --web-port 8080
```

Then open: `http://localhost:8080`

## Test Cases

### Test Case 1: Toggle Semantics on Home Page

**Steps:**
1. Open `http://localhost:8080`
2. Look for the accessibility icon in the top-right corner of the app bar
3. Click the accessibility icon (it should be grey, indicating semantics are disabled)
4. Observe the icon turns **green** (semantics enabled)
5. Check the URL in browser - it should now be `http://localhost:8080/?enableSemantics=true`

**Expected Results:**
- ✅ Icon changes from grey to green
- ✅ URL updated with `enableSemantics=true`
- ✅ Semantics are now active

**Verify Semantic DOM Elements:**

1. **Open DevTools (F12) → Elements tab**
2. **Press Ctrl+F or Cmd+F** to search
3. **Search for**: `flt-semantics`
4. **Expected with Semantics Enabled**: Multiple `<flt-semantics>` elements
5. **Expected with Semantics Disabled**: Very few or no `<flt-semantics>` elements

**Verify with Console (Most Important):**
```javascript
// Run in Chrome DevTools Console
const semanticsElements = document.querySelectorAll('flt-semantics');
console.log(`✅ Found ${semanticsElements.length} semantic elements`);

semanticsElements.forEach((el, i) => {
  console.log(`Element ${i}:`, el.outerHTML.substring(0, 200));
});
```

**Expected Results:**
- **Semantics Enabled**: 10+ semantic elements with roles, labels, descriptions
- **Semantics Disabled**: 0-2 semantic elements (minimal)

---

### Test Case 2: Navigate to Page 1 with Semantics Enabled

**Steps:**
1. Ensure semantics are enabled (green icon)
2. Click "Go to Page 1" button
3. Check that the URL is `http://localhost:8080/page1?enableSemantics=true`
4. Verify the app bar still shows the green accessibility icon
5. Check the page content shows "Semantics: Enabled" (green)

**Expected Results:**
- ✅ URL maintains `enableSemantics=true` parameter
- ✅ Green icon still visible in app bar
- ✅ Page content shows "Enabled" status
- ✅ Can click the accessibility icon (state is preserved)

**Verify with DevTools:**
1. Open Accessibility tab
2. **Expected**: Accessibility tree still rich and detailed
3. Navigate with Tab key - should hear/see all elements clearly

---

### Test Case 3: Navigate to Page 2 with Semantics Enabled

**Steps:**
1. From Page 1, click "Go to Page 2"
2. Check that the URL is `http://localhost:8080/page2?enableSemantics=true`
3. Verify green icon still visible
4. Check page shows "Semantics: Enabled"

**Expected Results:**
- ✅ URL parameter persists across navigation
- ✅ Semantics remain enabled on all pages
- ✅ Toggle button works (green icon clickable)

---

### Test Case 4: Toggle Semantics Off from Page 2

**Steps:**
1. On Page 2, click the green accessibility icon in the app bar
2. Observe the page reloads
3. After reload, verify icon is now grey (disabled)
4. Check the URL - `enableSemantics` parameter should be removed

**Expected Results:**
- ✅ Icon changes to grey
- ✅ URL shows `http://localhost:8080/page2` (no query parameter)
- ✅ Page shows "Semantics: Disabled" (red text)

**Verify with DevTools:**
1. Open Accessibility tab
2. **Expected**: Minimal accessibility tree (semantics disabled)
3. Navigate with Tab key - limited accessibility

---

### Test Case 5: Navigate Between Pages with Semantics Disabled

**Steps:**
1. With semantics disabled (grey icon), click "Go to Page 1"
2. Navigate: Page 1 → Home → Page 2 → Page 1
3. On each page, verify:
   - URL has no `enableSemantics` parameter
   - Icon remains grey
   - Status shows "Disabled" (red)

**Expected Results:**
- ✅ Semantics remain disabled across all pages
- ✅ URL parameters consistent (no semantics parameter)
- ✅ All navigation works correctly

---

### Test Case 6: Enable Semantics on Page 1

**Steps:**
1. Navigate to Page 1 with semantics disabled
2. Click the grey accessibility icon
3. Observe icon turns green
4. Page should show "Semantics: Enabled"

**Expected Results:**
- ✅ Icon changes to green
- ✅ URL updates to include `enableSemantics=true`
- ✅ Semantics activated immediately

---

### Test Case 7: URL Parameter Persistence

**Steps:**
1. Manually change URL to `http://localhost:8080/page1?enableSemantics=true`
2. Press Enter to load the page
3. Verify green icon appears immediately
4. Navigate: Page 1 → Page 2 → Home → Page 1
5. Check URL on each navigation

**Expected Results:**
- ✅ URL parameter persists: `?enableSemantics=true` on all pages
- ✅ Semantics remain enabled throughout navigation

**Test URL Variations:**
- `http://localhost:8080/?enableSemantics=true`
- `http://localhost:8080/page1?enableSemantics=false`
- `http://localhost:8080/page2?enableSemantics=true`
- `http://localhost:8080/?enableSemantics=False` (case test)

---

### Test Case 8: Automated Verification with DevTools Console

**Steps:**
1. Open Chrome DevTools (F12)
2. Go to **Console** tab
3. Run these commands to verify semantics state:

```javascript
// Check if Flutter semantics elements exist
console.log('Semantics elements:', document.querySelectorAll('flt-semantics').length);

// Check ARIA roles
console.log('ARIA roles:', document.querySelectorAll('[role]').length);

// Check ARIA labels
console.log('ARIA labels:', document.querySelectorAll('[aria-label]').length);

// Check buttons
console.log('Accessible buttons:', document.querySelectorAll('[role="button"]').length);

// Check page structure
console.log('Page elements:', document.querySelectorAll('*').length);
```

**Expected Results:**
- **Semantics Enabled**: High numbers (10+ semantics elements, multiple ARIA roles)
- **Semantics Disabled**: Low numbers (0-2 semantics elements, minimal roles)

---

### Test Case 9: Cross-Page Button State Verification

**Steps:**
1. Start on Home page with semantics enabled
2. Click "Go to Page 1" - verify icon still green
3. Click "Go to Page 2" - verify icon still green
4. Click "Go to Home" - verify icon still green
5. Toggle semantics off on Home page
6. Navigate to Page 1 - verify icon grey
7. Navigate to Page 2 - verify icon grey
8. Click icon to enable - verify becomes green
9. Navigate back to Page 1 - verify green

**Expected Results:**
- ✅ Icon color consistent across all pages
- ✅ Toggle state synchronized across navigation
- ✅ URL parameter reflects current state

---

### Test Case 10: Multiple Quick Navigations

**Steps:**
1. Rapidly navigate: Home → Page 1 → Page 2 → Home → Page 1
2. After each navigation, verify:
   - Current semantics state (icon color)
   - URL parameter presence/absence
   - Page content displays correct status

**Expected Results:**
- ✅ No state loss or desynchronization
- ✅ URL parameters maintain consistency
- ✅ Button works on every page

---

## Automated Detection Script

You can add this to Chrome DevTools Console for automated verification:

```javascript
function checkSemanticsStatus() {
  const semanticsCount = document.querySelectorAll('flt-semantics').length;
  const ariaRoles = document.querySelectorAll('[role]').length;
  const ariaLabels = document.querySelectorAll('[aria-label]').length;
  const buttons = document.querySelectorAll('[role="button"]').length;
  const urlParams = new URLSearchParams(window.location.search);
  const enableSemantics = urlParams.get('enableSemantics');
  
  const isEnabled = semanticsCount > 5 && ariaRoles > 10 && ariaLabels > 0;
  const urlEnabled = enableSemantics && enableSemantics.toLowerCase() === 'true';
  
  return {
    semanticsEnabled: isEnabled,
    urlState: urlEnabled,
    semanticsCount,
    ariaRoles,
    ariaLabels,
    buttons,
    currentPage: window.location.pathname,
    currentUrl: window.location.href,
    status: isEnabled && urlEnabled ? '✅ CORRECT' : (isEnabled !== urlEnabled ? '⚠️ MISMATCH' : '❌ INCORRECT')
  };
}

// Run check
console.table(checkSemanticsStatus());
```

**Expected Output:**
- `✅ CORRECT`: Semantics and URL match perfectly
- `⚠️ MISMATCH`: Semantics enabled but URL says disabled, or vice versa
- `❌ INCORRECT`: Neither semantics nor URL indicate enabled state

## Troubleshooting

### Issue: Button doesn't change color
**Solution**: Check browser console for errors, ensure app fully loaded

### Issue: URL parameter not updating
**Solution**: Check if `html.window.history.pushState` is working, may need page refresh

### Issue: State lost on navigation
**Solution**: Check that `MyAppState` is properly maintaining `_semanticsEnabled` state

### Issue: Semantics not activating
**Solution**: Verify `SemanticsBinding.instance.ensureSemantics()` is being called

## Success Criteria

✅ Semantics toggle button visible on all pages
✅ Button state (green/grey) consistent across navigation
✅ URL parameter persists across routes
✅ Clicking button enables/disables semantics immediately
✅ DevTools shows correct accessibility tree state
✅ Multiple rapid navigations don't break state
✅ URL parameter manipulation works correctly

---

## 🎯 Core DOM Verification Tests

### Primary Test: Check for Flutter Semantics Elements

**This is the most important test** - it verifies semantic HTML actually exists in the DOM.

**Steps:**
1. Open Chrome DevTools (F12)
2. Go to **Console** tab
3. Run this script:

```javascript
// Comprehensive semantics verification
function verifySemantics() {
  const fltSemantics = document.querySelectorAll('flt-semantics');
  const buttons = document.querySelectorAll('[role="button"]');
  const ariaLabels = document.querySelectorAll('[aria-label]');
  const roles = document.querySelectorAll('[role]');
  
  const url = new URLSearchParams(window.location.search);
  const urlEnabled = url.get('enableSemantics') === 'true';
  
  console.log('='.repeat(60));
  console.log('🎯 SEMANTICS VERIFICATION');
  console.log('='.repeat(60));
  console.log(`📊 Semantic Elements (flt-semantics): ${fltSemantics.length}`);
  console.log(`🔘 Buttons with role: ${buttons.length}`);
  console.log(`🏷️  ARIA Labels: ${ariaLabels.length}`);
  console.log(`🎭 Total Roles: ${roles.length}`);
  console.log(`🌐 URL Parameter: enableSemantics=${url.get('enableSemantics') || 'not set'}`);
  console.log('─'.repeat(60));
  
  // Display sample semantic elements
  if (fltSemantics.length > 0) {
    console.log('\n✅ Sample Semantic Elements:');
    fltSemantics.forEach((el, i) => {
      const role = el.getAttribute('role') || 'no role';
      const label = el.getAttribute('aria-label') || 'no label';
      console.log(`  ${i + 1}. Role: "${role}" | Label: "${label}"`);
    });
  }
  
  // Check if semantics are actually working
  const hasSubstantialSemantics = fltSemantics.length > 5 && buttons.length > 0;
  const isCorrect = hasSubstantialSemantics === urlEnabled;
  
  console.log('\n' + '='.repeat(60));
  if (isCorrect && hasSubstantialSemantics) {
    console.log('✅ SUCCESS: Semantics are ENABLED and working');
    console.log('   Screen readers can read this page!');
  } else if (isCorrect && !hasSubstantialSemantics) {
    console.log('✅ SUCCESS: Semantics are DISABLED');
    console.log('   Page has minimal accessibility (as expected)');
  } else {
    console.log('⚠️  MISMATCH: URL and actual semantics don\'t match!');
    console.log(`   URL says: ${urlEnabled ? 'ENABLED' : 'DISABLED'}`);
    console.log(`   Actual: ${hasSubstantialSemantics ? 'ENABLED' : 'DISABLED'}`);
  }
  console.log('='.repeat(60));
  
  return {
    fltSemanticsCount: fltSemantics.length,
    buttonsCount: buttons.length,
    ariaLabelsCount: ariaLabels.length,
    rolesCount: roles.length,
    urlEnabled,
    actuallyWorking: hasSubstantialSemantics,
    status: isCorrect ? 'CORRECT' : 'MISMATCH'
  };
}

verifySemantics();
```

**Expected Output When Semantics ENABLED:**
```
============================================================
🎯 SEMANTICS VERIFICATION
============================================================
📊 Semantic Elements (flt-semantics): 15+
🔘 Buttons with role: 5+
🏷️  ARIA Labels: 10+
🎭 Total Roles: 15+
🌐 URL Parameter: enableSemantics=true
────────────────────────────────────────────────────────────

✅ Sample Semantic Elements:
  1. Role: "button" | Label: "Enable Semantics"
  2. Role: "text" | Label: "Query String:"
  3. Role: "text" | Label: "(empty)"
  ...

============================================================
✅ SUCCESS: Semantics are ENABLED and working
   Screen readers can read this page!
============================================================
```

**Expected Output When Semantics DISABLED:**
```
============================================================
🎯 SEMANTICS VERIFICATION
============================================================
📊 Semantic Elements (flt-semantics): 0-2
🔘 Buttons with role: 0-1
🏷️  ARIA Labels: 0-1
🎭 Total Roles: 0-2
🌐 URL Parameter: enableSemantics=not set
────────────────────────────────────────────────────────────

============================================================
✅ SUCCESS: Semantics are DISABLED
   Page has minimal accessibility (as expected)
============================================================
```

---

### Automated Test Script for Continuous Monitoring

Run this in console to continuously monitor semantics state:

```javascript
// Run this to monitor semantics status
function monitorSemantics() {
  const check = verifySemantics();
  
  // Visual indicator in DOM
  document.body.style.border = check.actuallyWorking 
    ? '5px solid green' 
    : '5px solid red';
  
  document.title = `[${check.actuallyWorking ? 'ENABLED' : 'DISABLED'}] ${document.title}`;
}

// Auto-check on navigation
window.addEventListener('popstate', monitorSemantics);
monitorSemantics(); // Run immediately
```

This adds a **green or red border** around the page and updates the title to show current semantics state.

---

### VoiceOver Testing on Mac

**Critical Test**: Actually use VoiceOver to verify buttons are readable.

1. **Enable VoiceOver**: Press `Cmd+F5` (or enable in System Preferences)
2. **Navigate with VoiceOver**: 
   - Press `VO+Right Arrow` to move through elements
   - Should hear button labels
   - Should hear text content
3. **Activate buttons**: Press `Space` on a button
   - Should hear confirmation of button activation
4. **Key Elements to Test**:
   - "Enable Semantics" button - should be announced as button
   - "Go to Page 1" button - should be announced with label
   - Page text content - should be readable
   - Icon button in app bar - should have proper label

**Expected with Semantics Enabled:**
- ✅ "Enable Semantics, button" (VoiceOver announces)
- ✅ "Go to Page 1, button" (VoiceOver announces)
- ✅ All text content is read aloud
- ✅ Navigation is logical and smooth

**Expected with Semantics Disabled:**
- ❌ Minimal announcements
- ❌ Most content inaccessible
- ❌ Buttons may not be announced properly

