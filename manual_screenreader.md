# Manual Screen Reader Testing

Instructions for testing the app with Mac's built-in VoiceOver screen reader.

## Prerequisites

- Mac computer
- Safari browser (recommended for VoiceOver)
- VoiceOver enabled

## Enable VoiceOver

### Method 1: System Preferences
1. Go to **System Preferences** → **Accessibility** → **VoiceOver**
2. Check **Enable VoiceOver**
3. Press `Cmd+F5` to toggle VoiceOver on/off

### Method 2: Keyboard Shortcut
- Press `Cmd+F5` to toggle VoiceOver

## Testing Steps

### Step 1: Load App Without Semantics

1. **Open Safari**
2. **Navigate to**: `http://localhost:8080/` (no parameters)
3. **Enable VoiceOver**: Press `Cmd+F5` if not already enabled
4. **Navigate the page**: Use `Tab` key or `VO+Right Arrow` to move through elements

**Expected Behavior (Semantics Disabled):**
- VoiceOver will announce very little content
- Most elements will be inaccessible or announced as "group" or "image"
- Navigation will be difficult or impossible
- You may hear "Flutter" or "canvas" but not specific content

### Step 2: Enable Semantics via Button

1. **Click "Enable Semantics" button** (if you can find it)
2. **Navigate the page**: Use `Tab` key or `VO+Right Arrow`

**Expected Behavior (Semantics Enabled):**
- VoiceOver will announce all text content clearly
- Buttons will be announced as "button" with their labels
- You'll hear: "Enable Semantics button", "Disable Semantics button", etc.
- Navigation will be smooth and logical

### Step 3: Load App With Semantics Enabled

1. **Navigate to**: `http://localhost:8080/?enableSemantics=true`
2. **Enable VoiceOver**: Press `Cmd+F5` if not already enabled
3. **Navigate the page**: Use `Tab` key or `VO+Right Arrow`

**Expected Behavior:**
- Same as Step 2 - full accessibility support
- All content should be announced clearly
- Interactive elements should be properly identified

### Step 4: Test Invisible Button (Fallback Method)

If semantics are disabled, you can still enable them using Flutter's invisible button:

1. **Load page without semantics**: `http://localhost:8080/`
2. **Enable VoiceOver**: Press `Cmd+F5`
3. **Look for invisible button**: VoiceOver should announce "Enable accessibility button"
4. **Activate the button**: Press `Space` or `Enter`
5. **Navigate again**: Use `Tab` key or `VO+Right Arrow`

**Expected Behavior:**
- After clicking invisible button, semantics should be enabled
- All content should now be accessible to VoiceOver

## VoiceOver Navigation Commands

### Basic Navigation
- `VO+Right Arrow`: Move to next element
- `VO+Left Arrow`: Move to previous element
- `VO+Down Arrow`: Move into a group
- `VO+Up Arrow`: Move out of a group
- `Tab`: Move to next interactive element
- `Shift+Tab`: Move to previous interactive element

### Interaction
- `Space` or `Enter`: Activate buttons or links
- `VO+Space`: Click on current element
- `VO+Shift+Space`: Double-click on current element

### Information
- `VO+F`: Find text on page
- `VO+G`: Go to next heading
- `VO+Shift+G`: Go to previous heading
- `VO+L`: Go to next link
- `VO+Shift+L`: Go to previous link

## What VoiceOver Should Announce

### With Semantics Enabled ✅
```
"QueryString Semantics Demo, heading level 1"
"Query String, text"
"(empty), text" (or actual query string)
"Enable Semantics, text"
"true, text" (or false)
"Enable Semantics, button"
"Disable Semantics, button"
"Refresh, button"
"Disable Semantics Reload, button"
"Note: To disable semantics reload the page, text"
```

### With Semantics Disabled ❌
```
"Flutter" (or similar generic announcement)
"group" (repeated for different areas)
"image" (for canvas elements)
Very limited or no specific content announcements
```

## Testing Checklist

### Semantics Disabled Test
- [ ] Load page without `enableSemantics=true`
- [ ] Enable VoiceOver
- [ ] Navigate with `Tab` or `VO+Right Arrow`
- [ ] Verify limited accessibility (should be difficult to navigate)
- [ ] Look for invisible "Enable accessibility" button
- [ ] Click invisible button if found
- [ ] Verify semantics are now enabled

### Semantics Enabled Test
- [ ] Load page with `enableSemantics=true` OR click "Enable Semantics" button
- [ ] Enable VoiceOver
- [ ] Navigate with `Tab` or `VO+Right Arrow`
- [ ] Verify all content is announced clearly
- [ ] Test all buttons are accessible
- [ ] Verify logical navigation order

### Button Testing
- [ ] "Enable Semantics" button should announce properly
- [ ] "Disable Semantics" button should announce properly
- [ ] "Refresh" button should announce properly
- [ ] "Disable Semantics (Reload)" button should announce properly
- [ ] All buttons should be activatable with `Space` or `Enter`

## Troubleshooting

### VoiceOver Not Working?
1. **Check VoiceOver is enabled**: Press `Cmd+F5`
2. **Check Safari**: VoiceOver works best with Safari
3. **Check system volume**: VoiceOver uses system audio
4. **Restart VoiceOver**: Press `Cmd+F5` twice (off then on)

### Can't Find Elements?
1. **Use Tab navigation**: Press `Tab` to move through interactive elements
2. **Use VO+Right Arrow**: Move through all elements sequentially
3. **Check if semantics are enabled**: Look for invisible "Enable accessibility" button
4. **Try different browser**: Test in Chrome or Firefox

### Semantics Not Working?
1. **Check URL**: Ensure `enableSemantics=true` is present
2. **Refresh page**: Semantics are set at page load
3. **Try invisible button**: Look for "Enable accessibility" button
4. **Check console**: Look for JavaScript errors in browser

### VoiceOver Commands Not Working?
1. **Check VoiceOver focus**: Ensure VoiceOver is focused on the browser
2. **Try different commands**: Some commands may not work in web context
3. **Use Tab navigation**: Fall back to standard keyboard navigation
4. **Check VoiceOver settings**: Ensure web navigation is enabled

## Alternative Screen Readers

### NVDA (Windows)
- Download from [nvaccess.org](https://www.nvaccess.org/)
- Free screen reader for Windows
- Similar testing approach

### JAWS (Windows)
- Commercial screen reader
- More advanced features
- Similar testing approach

### ChromeVox (Chrome Extension)
- Install ChromeVox extension
- Works in Chrome browser
- Good for quick testing

## Expected Results Summary

| Test Case | VoiceOver Behavior | Accessibility Level |
|-----------|-------------------|-------------------|
| No semantics | Minimal announcements, difficult navigation | Poor ❌ |
| Semantics enabled | Full announcements, easy navigation | Excellent ✅ |
| Invisible button clicked | Transitions from poor to excellent | Good ✅ |

The key difference is that with semantics enabled, VoiceOver can properly announce all content and provide logical navigation, while without semantics, the app is essentially inaccessible to screen readers.

