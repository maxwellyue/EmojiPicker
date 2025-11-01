# EmojiPicker

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2016.0%2B%20%7C%20macOS%2013.0%2B-lightgrey.svg)](Package.swift)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](Package.swift)

## About

<b>A native SwiftUI emoji picker library supporting both iOS、macCatalyst and macOS.</b>

## Navigation

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)

## Requirements

- Swift `5.9+`
- iOS 16.0+
- macOS 13.0+
- SwiftUI native implementation

## Installation

### Swift Package Manager

Add `EmojiPicker` to your project using Xcode:

1. File > Add Package Dependencies
2. Enter package URL: `https://github.com/maxwellyue/EmojiPicker`
3. Select version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/maxwellyue/EmojiPicker", from: "1.0.0")
]
```

## Quick Start

Add the emoji picker to any SwiftUI view using the `.emojiPicker` modifier:

```swift
import SwiftUI
import EmojiPicker

struct ContentView: View {
    @State private var selectedEmoji = "😀"
    @State private var showPicker = false
    
    var body: some View {
        Button(selectedEmoji) {
            showPicker = true
        }
        .emojiPicker(
            isPresented: $showPicker,
            selectedEmoji: $selectedEmoji
        )
    }
}
```

Or use the picker directly:

```swift
EmojiPicker(
    selectedEmoji: $selectedEmoji,
    isDismissAfterChoosing: true,
    selectedCategoryTintColor: .blue
)
```

## Usage

### Using the View Modifier

The easiest way to use EmojiPicker is with the `.emojiPicker()` modifier:

```swift
.emojiPicker(
    isPresented: $showPicker,
    selectedEmoji: $selectedEmoji,
    isDismissAfterChoosing: true,           // Default: true
    selectedCategoryTintColor: .blue         // Default: .blue
)
```

### Using the Picker Directly

You can also use the picker as a standalone view:

```swift
EmojiPicker(
    selectedEmoji: $selectedEmoji,
    isDismissAfterChoosing: true,
    selectedCategoryTintColor: .blue
)
```

### Parameters

- **isPresented**: Binding to control picker visibility
- **selectedEmoji**: Binding that receives the selected emoji string
- **isDismissAfterChoosing**: Whether to dismiss after selection (default: `true`)

## Examples

### Basic Usage

```swift
import SwiftUI
import EmojiPicker

struct MyView: View {
    @State private var emoji = "😀"
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            Text("Selected: \(emoji)")
            
            Button("Choose Emoji") {
                showPicker = true
            }
        }
        .emojiPicker(
            isPresented: $showPicker,
            selectedEmoji: $emoji
        )
    }
}
```
