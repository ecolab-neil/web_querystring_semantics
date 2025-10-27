# Testing Instructions

How to test the semantics functionality using Chrome DevTools and other methods.

## Quick Test Methods

### Method 1: Chrome DevTools (Easiest)

1. **Open Chrome DevTools**
   - Right-click on the page → "Inspect" 
   - Or press `F12` or `Ctrl+Shift+I` (Windows/Linux) / `Cmd+Option+I` (Mac)

2. **Check Accessibility Tree**
   - Click the **Accessibility** tab in DevTools
   - If semantics are enabled, you'll see a detailed accessibility tree
   - If semantics are disabled, you'll see minimal or no accessibility information

3. **Compare Before/After**
   - Load page without `enableSemantics=true` → Check accessibility tree (should be minimal)
   - Click "Enable Semantics" button → Check accessibility tree (should be detailed)
   - Look for ARIA roles, labels, and semantic structure

### Method 2: Browser Console Check

1. **Open Console**
   - Press `F12` → Console tab
   - Or right-click → "Inspect" → Console tab

2. **Check for Semantics Elements**
   ```javascript
   // Check if accessibility elements exist
   document.querySelectorAll('[role]').length
   
   // Check for Flutter semantics elements
   document.querySelectorAll('flt-semantics').length
   
   // Check for ARIA attributes
   document.querySelectorAll('[aria-label]').length
   ```

3. **Expected Results**
   - **Semantics Disabled**: Low numbers (0-2 elements)
   - **Semantics Enabled**: Higher numbers (10+ elements)

### Method 3: DOM Inspection

1. **Open Elements Tab**
   - Press `F12` → Elements tab

2. **Look for Semantics Elements**
   - **Semantics Disabled**: Minimal DOM structure, mostly canvas elements
   - **Semantics Enabled**: Rich DOM with `flt-semantics` elements, ARIA roles, and accessibility attributes

3. **Search for Accessibility Elements**
   - Press `Ctrl+F` (Windows/Linux) or `Cmd+F` (Mac)
   - Search for: `flt-semantics`, `role=`, `aria-label=`

## Detailed Testing Steps

### Test 1: Initial Load (Semantics Disabled)

1. Load: `http://localhost:8080/`
2. Open DevTools → Accessibility tab
3. **Expected**: Minimal accessibility tree, mostly just basic page structure

### Test 2: Enable Semantics via Button

1. Click "Enable Semantics" button
2. Open DevTools → Accessibility tab  
3. **Expected**: Rich accessibility tree with:
   - Button roles for clickable elements
   - Text elements with proper labels
   - Navigation structure
   - Form controls with labels

### Test 3: Enable Semantics via URL

1. Load: `http://localhost:8080/?enableSemantics=true`
2. Open DevTools → Accessibility tab
3. **Expected**: Same rich accessibility tree as Test 2

### Test 4: Disable Semantics

1. Click "Disable Semantics (Reload)" button
2. Open DevTools → Accessibility tab
3. **Expected**: Back to minimal accessibility tree

## What to Look For

### Semantics Enabled ✅
- **ARIA roles**: `role="button"`, `role="text"`, `role="heading"`
- **Labels**: `aria-label` attributes on interactive elements
- **Structure**: Proper heading hierarchy (`h1`, `h2`, etc.)
- **Form controls**: Labels associated with inputs
- **Navigation**: Landmark roles (`main`, `navigation`, `banner`)

### Semantics Disabled ❌
- **Minimal structure**: Only basic page elements
- **No ARIA roles**: Missing or generic roles
- **No labels**: Interactive elements without descriptions
- **Canvas-based**: Most content rendered on canvas (not accessible)

## Console Commands for Testing

```javascript
// Count accessibility elements
console.log('ARIA roles:', document.querySelectorAll('[role]').length);
console.log('ARIA labels:', document.querySelectorAll('[aria-label]').length);
console.log('Semantics elements:', document.querySelectorAll('flt-semantics').length);

// Check specific elements
document.querySelectorAll('[role="button"]').forEach((el, i) => {
  console.log(`Button ${i}:`, el.getAttribute('aria-label') || el.textContent);
});

// Check if semantics are active
console.log('Semantics active:', document.querySelectorAll('flt-semantics').length > 0);
```

## Troubleshooting

### Semantics Not Working?
1. **Check URL**: Ensure `enableSemantics=true` is in the URL
2. **Refresh Page**: Semantics are set at page load
3. **Check Console**: Look for Flutter errors
4. **Verify Build**: Make sure you're running `flutter build web --release`

### DevTools Not Showing Accessibility Tab?
1. **Update Chrome**: Use latest version
2. **Enable Experimental Features**: 
   - Go to `chrome://flags/`
   - Search for "accessibility"
   - Enable accessibility-related flags

### Still Not Working?
1. **Check Network Tab**: Ensure all Flutter resources loaded
2. **Check Console**: Look for JavaScript errors
3. **Try Different Browser**: Test in Firefox or Safari
4. **Clear Cache**: Hard refresh with `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac)

## Expected Accessibility Tree Structure

### When Semantics Enabled:
```
Document
├── Main (role="main")
│   ├── Heading (role="heading", level=1)
│   │   └── "QueryString Semantics Demo"
│   ├── Text (role="text")
│   │   └── "Query String:"
│   ├── Text (role="text")
│   │   └── "(empty)" or actual query string
│   ├── Text (role="text")
│   │   └── "Enable Semantics:"
│   ├── Text (role="text")
│   │   └── "true" or "false"
│   ├── Button (role="button")
│   │   └── "Enable Semantics"
│   ├── Button (role="button")
│   │   └── "Disable Semantics"
│   ├── Button (role="button")
│   │   └── "Refresh"
│   └── Button (role="button")
│       └── "Disable Semantics (Reload)"
```

### When Semantics Disabled:
```
Document
└── Canvas (minimal structure)
    └── Flutter app content (not accessible)
```

