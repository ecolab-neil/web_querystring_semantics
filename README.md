# QueryString Semantics Demo

A Flutter web application that demonstrates querystring parsing and conditional semantics enabling.

## Overview

This app displays the current URL querystring and shows whether semantics are enabled based on the `enableSemantics` parameter. Semantics are only enabled when `enableSemantics=true` is present in the querystring.

## Features

- **QueryString Display**: Shows the current URL querystring (or "(empty)" if none)
- **Semantics Status**: Displays `true` or `false` based on querystring value
- **Visual Indicators**: 
  - Query string text is grey when empty, black when present
  - Semantics status is green when `true`, red when `false`
- **Refresh Button**: Allows manual refresh of querystring parsing

## How to Test

### Prerequisites
- Flutter SDK installed
- Web browser for testing

### Running the App

1. **Start the Flutter web server:**
   ```bash
   flutter run -d web-server --web-port 8080
   ```

2. **Open your browser** and navigate to `http://localhost:8080`

### Testing Different QueryString Values

Test the following URLs to see different behaviors:

#### 1. No QueryString (Semantics Disabled)
```
http://localhost:8080
```
- Query String: `(empty)`
- Enable Semantics: `false` (red)

#### 2. enableSemantics=true (Semantics Enabled)
```
http://localhost:8080?enableSemantics=true
```
- Query String: `enableSemantics=true`
- Enable Semantics: `true` (green)

#### 3. enableSemantics=false (Semantics Disabled)
```
http://localhost:8080?enableSemantics=false
```
- Query String: `enableSemantics=false`
- Enable Semantics: `false` (red)

#### 4. Case Insensitive Examples (Semantics Enabled)
```
http://localhost:8080?enableSemantics=True
http://localhost:8080?enableSemantics=TRUE
http://localhost:8080?enableSemantics=TrUe
```
- Query String: `enableSemantics=True` (or any case variation)
- Enable Semantics: `true` (green)

#### 5. Other Parameters (Semantics Disabled)
```
http://localhost:8080?test=value
http://localhost:8080?enabled=true
http://localhost:8080?param=value
```
- Query String: `test=value` (or whatever you put)
- Enable Semantics: `false` (red)

#### 6. Multiple Parameters with enableSemantics=true
```
http://localhost:8080?param1=value1&enableSemantics=true&param2=value2
```
- Query String: `param1=value1&enableSemantics=true&param2=value2`
- Enable Semantics: `true` (green)

#### 7. Multiple Parameters without enableSemantics=true
```
http://localhost:8080?param1=value1&param2=value2
```
- Query String: `param1=value1&param2=value2`
- Enable Semantics: `false` (red)

### Testing Notes

- **Parameter-based**: Semantics are enabled ONLY when `enableSemantics=true` is present in the querystring
- **Case insensitive**: `enableSemantics=true`, `enableSemantics=True`, `enableSemantics=TRUE` all work
- **Value sensitive**: Only `enableSemantics=true` (case insensitive) enables semantics; `enableSemantics=false` or any other value disables it
- **Refresh functionality**: Use the "Refresh" button to re-parse the current URL without reloading the page
- **Real-time updates**: Change the URL in the browser address bar and click "Refresh" to see immediate updates

### Expected Behavior Summary

| QueryString | Enable Semantics | Display Color |
|-------------|------------------|---------------|
| (empty)     | `false`          | Red           |
| `enableSemantics=true` | `true` | Green         |
| `enableSemantics=false` | `false` | Red         |
| `test=value` | `false`        | Red           |
| `enabled=true` | `false`      | Red           |
| `param1=value1&enableSemantics=true&param2=value2` | `true` | Green |
| Any other value | `false`      | Red           |

## Technical Details

- Built with Flutter for web
- Uses `dart:html` to access browser URL
- Uses `Uri.queryParameters` to parse querystring parameters
- Stateful widget with manual refresh capability
- Material Design UI with responsive layout
