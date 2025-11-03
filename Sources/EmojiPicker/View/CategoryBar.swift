// The MIT License (MIT)
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

/// 底部分类栏视图
struct CategoryBar: View {
    let categories: [EmojiCategory]
    @Binding var selection: EmojiCategoryType?

    private let categoryIcons: [EmojiCategoryType: String] = [
        .frequentlyUsed: "clock",
        .people: "face.smiling",
        .nature: "dog",
        .foodAndDrink: "fork.knife",
        .activity: "soccerball",
        .travelAndPlaces: "car",
        .objects: "lightbulb",
        .symbols: "heart",
        .flags: "flag"
    ]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(categories.enumerated()), id: \.offset) { _, category in
                Button {
                    selection = category.type
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: categoryIcons[category.type] ?? "questionmark")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .help(category.categoryName)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .modify {
            if #available(iOS 17.0, macOS 14.0, *) {
                $0.sensoryFeedback(.selection, trigger: self.selection)
            } else {
                $0
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
#Preview {
    @Previewable @State var selection: EmojiCategoryType?
    CategoryBar(categories: UnicodeManager().getEmojisForCurrentIOSVersion(),
                selection: $selection)
}
