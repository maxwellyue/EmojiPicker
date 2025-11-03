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

/// Emoji 单元格视图，支持肤色选择
struct EmojiCell: View {
    let emoji: Emoji
    let categoryType: EmojiCategoryType
    let onSelect: (String) -> Void

    @State private var isHovering = false
    @State private var showPopover = false

    // 使用 computed property 来获取当前 emoji 的皮肤色调，确保每次访问都是最新的
    private var currentSkinTone: EmojiSkinTone {
        emoji.skinTone ?? .none
    }

    // 使用 computed property 来获取当前 emoji 的字符串表示，确保每次访问都从 UserDefaults 读取
    private var currentEmojiString: String {
        emoji.string
    }

    private var label: some View {
        // 使用 emoji 的唯一标识和当前皮肤色调作为 id
        // 当皮肤色调变化时，只有对应的 cell 会重新渲染
        // 不包含 selectedEmoji 避免所有 cell 都被重新创建
        Text(currentEmojiString)
            .font(.title)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .id("emoji-\(emoji.emojiKeys.map(String.init).joined(separator: "-"))-skin-\(currentSkinTone.rawValue)")
            .background(isHovering ? Color.gray.opacity(0.15) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
    }

    var body: some View {
        label
            .onTapGesture {
                emoji.incrementUsageCount()
                onSelect(emoji.string)
            }
            .onLongPressGesture {
                if emoji.isSkinToneSupport {
                    showPopover = true
                }
            }
            .alwaysPopover(isPresented: $showPopover) {
                HStack(spacing: 0) {
                    emojiItem(for: .none)
                        .frame(width: 36, alignment: .center)
                    Divider()
                        .frame(width: 16)
                    ForEach(EmojiSkinTone.effectiveValues, id: \.rawValue) { skinTone in
                        emojiItem(for: skinTone)
                    }
                }
                .font(.headline)
                .frame(width: 36 * 6 + 16 + 12, height: 28)
            }
            .onHover { hovering in
                isHovering = hovering
            }
    }

    private func emojiItem(for skinTone: EmojiSkinTone) -> some View {
        Button(action: {
            self.showPopover = false
            selectSkinTone(skinTone)
        }) {
            Text(previewEmoji(for: skinTone))
                .frame(width: 36, alignment: .center)
        }
        .buttonStyle(.borderless)
    }

    private var pickerStyle: some PickerStyle {
        if #available(iOS 17.0, macOS 14.0, *) {
            return .palette
        } else {
            return .inline
        }
    }

    // MARK: - Private Methods

    private func selectSkinTone(_ skinTone: EmojiSkinTone) {
        // 保存皮肤色调到 UserDefaults
        emoji.set(skinToneRawValue: skinTone.rawValue)
        emoji.incrementUsageCount()
        // 由于皮肤色调已保存到 UserDefaults，emoji.string 会自动读取最新的皮肤色调
        // 直接选择 emoji
        onSelect(emoji.string)
    }

    /// 生成预览 emoji 字符串，不保存到 UserDefaults
    private func previewEmoji(for skinTone: EmojiSkinTone) -> String {
        guard emoji.isSkinToneSupport,
              let skinToneKey = skinTone.skinKey
        else {
            return emoji.emojiKeys.emoji()
        }
        var bufferEmojiKeys = emoji.emojiKeys
        bufferEmojiKeys.insert(skinToneKey, at: 1)
        return bufferEmojiKeys.emoji()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var selectedEmoji = ""
    EmojiPicker(
        selection: $selectedEmoji,
        isDismissAfterChoosing: true
    )
}
