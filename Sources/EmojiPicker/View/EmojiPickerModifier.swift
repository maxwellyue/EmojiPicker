// The MIT License (MIT)
//
// Copyright © 2025 Maxwell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI

/// View modifier to present emoji picker as a sheet
public struct EmojiPickerModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selection: String
    let isDismissAfterChoosing: Bool

    public func body(content: Content) -> some View {
        content
        #if targetEnvironment(macCatalyst) || os(macOS)
        .popover(isPresented: $isPresented) {
            EmojiPicker(
                selection: $selection,
                isDismissAfterChoosing: isDismissAfterChoosing
            )
            .frame(width: 400, height: 600)
        }
        #else
        .sheet(isPresented: $isPresented) {
                EmojiPicker(
                    selection: $selection,
                    isDismissAfterChoosing: isDismissAfterChoosing
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        #endif
    }
}

public extension View {
    /// Presents an emoji picker as a sheet
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation
    ///   - selectedEmoji: Binding to receive the selected emoji
    ///   - isDismissAfterChoosing: Whether to dismiss after selecting an emoji (default: true)
    ///   - selectedCategoryTintColor: Color for the selected category (default: .blue)
    func emojiPicker(
        isPresented: Binding<Bool>,
        selection: Binding<String>,
        isDismissAfterChoosing: Bool = true
    ) -> some View {
        modifier(EmojiPickerModifier(
            isPresented: isPresented,
            selection: selection,
            isDismissAfterChoosing: isDismissAfterChoosing
        ))
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var isPresented = true
    @Previewable @State var selectedEmoji = ""
    VStack {
        Button(action: {
            isPresented.toggle()
        }) {
            Text(verbatim: "Show Emoji Picker")
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .emojiPicker(isPresented: $isPresented, selection: $selectedEmoji)

        Text(selectedEmoji)
            .font(.largeTitle)
    }
}
