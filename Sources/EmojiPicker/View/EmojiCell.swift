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

/// Emoji 单元格视图，支持肤色选择
struct EmojiCell: View {
    let emoji: Emoji
    let categoryType: EmojiCategoryType
    @ObservedObject var viewModel: EmojiPickerViewModel

    @State private var isHovering = false
    @State private var selectedSkinTone: EmojiSkinTone = .none

    var body: some View {
        Menu {
            if emoji.isSkinToneSupport {
                Picker(selection: Binding(
                    get: { emoji.skinTone ?? .none },
                    set: { newValue in
                        selectSkinTone(newValue)
                    }
                )) {
                    ForEach(EmojiSkinTone.allCases, id: \.rawValue) { skinTone in
                        Text(previewEmoji(for: skinTone))
                            .tag(skinTone)
                    }
                } label: {
                    EmptyView()
                }
                .pickerStyle(pickerStyle)
            } else {
                Picker(selection: .constant(true)) {
                    ForEach([true], id: \.self) { _ in
                        Text(emoji.string)
                            .tag(true)
                    }
                } label: {
                    EmptyView()
                }
                .pickerStyle(pickerStyle)
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Text(emoji.string)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)

                // 显示小圆点提示支持肤色
                if emoji.isSkinToneSupport {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                        .offset(x: -6, y: -6)
                }
            }
            .background(isHovering ? Color.gray.opacity(0.15) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
        } primaryAction: {
            // 点击直接选择当前肤色的 emoji
            viewModel.selectedEmoji = emoji
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
        }
        .buttonStyle(.borderless)
        #if os(macOS)
            .onHover { hovering in
                isHovering = hovering
            }
        #endif
    }

    private var pickerStyle: some PickerStyle {
        if #available(iOS 17.0, *) {
            return .palette
        } else {
            return .inline
        }
    }

    // MARK: - Private Methods

    private func selectSkinTone(_ skinTone: EmojiSkinTone) {
        viewModel.updateEmojiSkinTone(skinTone, for: emoji, in: categoryType)
        selectedSkinTone = skinTone
    }

    private func previewEmoji(for skinTone: EmojiSkinTone) -> String {
        let tempEmoji = emoji
        tempEmoji.set(skinToneRawValue: skinTone.rawValue)
        return tempEmoji.string
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var selectedEmoji = ""

    EmojiPicker(
        selectedEmoji: $selectedEmoji,
        isDismissAfterChoosing: true
    )
}
