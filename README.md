# EmojiPicker

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2016.0%2B%20%7C%20macOS%2013.0%2B-lightgrey.svg)](Package.swift)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](Package.swift)

<p float="left">
<img src="https://user-images.githubusercontent.com/50948518/216799717-25b3e4ed-b4c5-4166-91a2-72374b0564f9.gif" width="280">
</p>

## About

<b>A native SwiftUI emoji picker library supporting both iOS and macOS.</b>
<br><br>
**Version 2.0+** is a complete rewrite in SwiftUI with full support for iOS 16+ and macOS 13+. The library now provides a native, cross-platform experience with modern SwiftUI patterns.
<br><br>
If you are interested in how I developed the original UIKit version and what difficulties I encountered in the process, you can read an article on [Medium](https://medium.com/@izzyumkin/an-emoji-selection-element-aka-emojipicker-for-ios-like-in-macos-e2fa022b80af), [Habr](https://habr.com/ru/post/716194/) about it.
And if you like the project, don't forget to `put star ★`.

#### Limitations
- Does not support two part emojis. For example:
  - [x] Supported: 🤝🏻 🤝🏿
  - [ ] Not supported: 🫱🏿‍🫲🏻 🫱🏼‍🫲🏿
  
If you know how to fix it - welcome to the [discussion](https://github.com/izyumkin/MCEmojiPicker/discussions/10).

## Apps Using

<p float="left">
    <a href="https://apps.apple.com/app/id1500111859"><img src="https://github.com/user-attachments/assets/bc8b8235-b848-43ef-a143-fbce80c195d3" height="65"></a>
    <a href="https://apps.apple.com/app/id6450279059"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/270146ff-d3e7-4c46-97c2-2c796e6bd78d" height="65"></a>
    <a href="https://apps.apple.com/app/id6444636956"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/ecae445c-1683-422b-a0e7-8dbaeac2eb18" height="65"></a>
    <a href="https://github.com/Housemates-Mobile-App/housemates_mobileapp"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/05a8651a-c6fb-419e-9bdc-aa7d68b53af7" height="65"></a>
    <a href="https://github.com/RedEagle-dh/Quantify"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/bfa48cc4-c901-4235-8bfc-f5fb0fa22279" height="65"></a>
    <a href="https://github.com/norbusonam/routine"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/97a5b6ee-0cff-4839-894e-5c2d08daca3a" height="65"></a>
    <a href="https://github.com/bapaws/clock"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/7a615b02-43a2-4557-bfbd-7f40841ac508" height="65"></a>
    <a href="https://github.com/fn1y/Habitrack"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/0b634a00-257f-4e9d-93b0-8f8a2c0d335d" height="65"></a>
    <a href="https://github.com/honzachalupa/SymptomsTracker"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/836c08c8-7e60-4403-ad0a-fffaed926d15" height="65"></a>
    <a href="https://github.com/savoirfairelinux/jami-client-ios"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/b2e00327-7c13-407b-8c43-3c189504c3c5" height="65"></a>
    <a href="https://github.com/deltachat/deltachat-ios"><img src="https://github.com/izyumkin/MCEmojiPicker/assets/50948518/6322e6cf-71d4-4f37-893c-44277b277517" height="65"></a>
    <a href="https://apps.apple.com/app/id6465843931"><img src="https://github.com/user-attachments/assets/efc4408b-f716-4773-b255-d267c2fb5bf7" height="65"></a>
    <a href="https://apps.apple.com/app/id6499061841"><img src="https://github.com/user-attachments/assets/13bab9ec-7c73-4a3b-bf52-c5c5d3ce14b0" height="65"></a>
    <a href="https://apps.apple.com/app/id6476229386"><img src="https://github.com/user-attachments/assets/fefc767e-5d07-4bb7-b83a-b190e2188ddb" height="65"></a>
</p>

If you use a `MCEmojiPicker`, add your application via Pull Request. Fore more information you can see [contribution guide](https://github.com/izyumkin/MCEmojiPicker/blob/main/CONTRIBUTING.md).

## Navigation

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
    - [Selected emoji category tint color](#selected-emoji-category-tint-color)
    - [Arrow direction](#arrow-direction)
    - [Horizontal inset](#horizontal-inset)
    - [Is dismiss after choosing](#is-dismiss-after-choosing)
    - [Custom height](#custom-height)
    - [Feedback generator style](#feedback-generator-style)
- [SwiftUI](#swiftui)
- [Localization](#localization)
- [TODO](#todo)

## Requirements

- Swift `5.9+`
- iOS 16.0+
- macOS 13.0+
- SwiftUI native implementation

## Installation

### Swift Package Manager

Add `EmojiPicker` to your project using Xcode:

1. File > Add Package Dependencies
2. Enter package URL: `https://github.com/izyumkin/MCEmojiPicker`
3. Select version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/izyumkin/MCEmojiPicker", from: "2.0.0")
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

The easiest way to use MCEmojiPicker is with the `.emojiPicker()` modifier:

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
- **selectedCategoryTintColor**: Color for selected category (default: `.blue`)

### Platform-Specific Features

- **iOS**: Includes haptic feedback on emoji selection
- **macOS**: Supports hover states and keyboard navigation
- **Both**: Context menu for skin tone selection (right-click or long-press)

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

### Custom Styling

```swift
.emojiPicker(
    isPresented: $showPicker,
    selectedEmoji: $emoji,
    isDismissAfterChoosing: false,
    selectedCategoryTintColor: .purple
)
```

### macOS Window

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Localization
🌍 This library supports all existing localizations

## TODO

-   [x] The main functionality for choosing emojis
-   [x] Dark mode
-   [x] Segmented control for jumping an emoji section
-   [x] Automatic adjustment of the relevant set of emoji for the iOS version
-   [x] Select skin tones from popup
-   [x] Frequently used
-   [ ] Search bar and search results
