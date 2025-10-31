// The MIT License (MIT)
// Copyright © 2024 Ivan Izyumkin
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
#if os(iOS)
import UIKit
#endif

/// 底部分类栏视图
struct CategoryBar: View {
    let categories: [EmojiCategory]
    @Binding var selectedCategory: EmojiCategoryType?
    let categoryIcons: [EmojiCategoryType: String]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                Button {
                    selectedCategory = category.type

                    #if os(iOS)
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    #endif
                } label: {
                    VStack(spacing: 4) {
                        let isSelected = (selectedCategory == category.type)
                        Image(systemName: categoryIcons[category.type] ?? "questionmark")
                            .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                            .foregroundStyle(isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(Color.secondary))

                        if selectedCategory == category.type {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.tint)
                                .frame(width: 24, height: 3)
                        } else {
                            Color.clear
                                .frame(width: 24, height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                #if os(macOS)
                    .help(category.categoryName)
                #endif
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.pickerBackground)
    }
}
