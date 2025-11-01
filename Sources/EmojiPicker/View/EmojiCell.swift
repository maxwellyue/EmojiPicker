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

/// Emoji 单元格视图，支持肤色选择
struct EmojiCell: View {
    let emoji: Emoji
    let categoryType: EmojiCategoryType
    @ObservedObject var viewModel: EmojiPickerViewModel

    @State private var isHovering = false

    // 使用 computed property 来获取当前 emoji 的皮肤色调，确保每次访问都是最新的
    private var currentSkinTone: EmojiSkinTone {
        emoji.skinTone ?? .none
    }

    // 使用 computed property 来获取当前 emoji 的字符串表示，确保每次访问都从 UserDefaults 读取
    private var currentEmojiString: String {
        emoji.string
    }

    private var label: some View {
        // 使用 emoji 的唯一标识、当前皮肤色调和 viewModel 的 selectedEmoji 作为 id
        // 这样当 viewModel.selectedEmoji 更新时（包括皮肤色调更新），视图会强制刷新
        // 刷新时会重新评估 currentSkinTone 和 currentEmojiString，确保显示正确的皮肤色调
        Text(currentEmojiString)
            .font(.title)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .id("emoji-\(emoji.emojiKeys.map(String.init).joined(separator: "-"))-skin-\(currentSkinTone.rawValue)-selected-\(viewModel.selectedEmoji?.emojiKeys.map(String.init).joined(separator: "-") ?? "none")")
            .background(isHovering ? Color.gray.opacity(0.15) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
    }

    var body: some View {
        Group {
            if emoji.isSkinToneSupport {
                Menu {
                    if emoji.isSkinToneSupport {
                        Picker(selection: Binding(
                            get: { currentSkinTone },
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
                                Text(currentEmojiString)
                                    .tag(true)
                            }
                        } label: {
                            EmptyView()
                        }
                        .pickerStyle(pickerStyle)
                    }
                } label: {
                    self.label
                } primaryAction: {
                    viewModel.selectedEmoji = emoji
                }
            } else {
                Button(action: {
                    viewModel.selectedEmoji = emoji
                }) {
                    self.label
                }
            }
        }
        .buttonStyle(.borderless)
        .onHover { hovering in
            isHovering = hovering
        }
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
        viewModel.updateEmojiSkinTone(skinTone, for: emoji, in: categoryType)
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
