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

/// 主 Emoji 选择器视图
public struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss

    @Binding public var selection: String
    public var isDismissAfterChoosing: Bool

    public init(selection: Binding<String>, isDismissAfterChoosing: Bool = true, unicodeManager: UnicodeManagerProtocol = UnicodeManager()) {
        self._selection = selection
        self.isDismissAfterChoosing = isDismissAfterChoosing
        self.unicodeManager = unicodeManager
    }

    @State private var currentCategory: EmojiCategoryType? = .frequentlyUsed
    @State private var allEmojiCategories: [EmojiCategory] = []
    private let unicodeManager: UnicodeManagerProtocol

    var frequentlyUsedCategory: EmojiCategory? {
        allEmojiCategories.first(where: { $0.type == .frequentlyUsed })
    }

    var standardCategories: [EmojiCategory] {
        allEmojiCategories.filter { $0.type != .frequentlyUsed }
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            if let frequentlyUsedCategory {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: .infinity), spacing: 12)], spacing: 12) {
                                    CategorySection(
                                        category: frequentlyUsedCategory,
                                        onSelect: { emojiString in
                                            selection = emojiString
                                            if isDismissAfterChoosing {
                                                dismiss()
                                            }
                                        }
                                    )
                                }
                            }

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: .infinity), spacing: 12)], spacing: 12) {
                                ForEach(standardCategories, id: \.type) { category in
                                    CategorySection(
                                        category: category,
                                        onSelect: { emojiString in
                                            selection = emojiString
                                            if isDismissAfterChoosing {
                                                dismiss()
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .onChange(of: currentCategory) { newType in
                        guard let newType else { return }
                        withAnimation {
                            scrollProxy.scrollTo(newType, anchor: .top)
                        }
                    }
                }

                Divider()

                CategoryBar(categories: allEmojiCategories, selection: $currentCategory)
            }
            .navigationTitle("Emoji")
            #if os(iOS) || targetEnvironment(macCatalyst)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    if !isDismissAfterChoosing {
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                .background({
                    #if os(macOS)
                        return Color(nsColor: .controlBackgroundColor)
                    #else
                        return Color(uiColor: .systemGroupedBackground)
                    #endif
                }())
        }
        .task {
            // 初始化 emoji 分类
            allEmojiCategories = unicodeManager.getEmojisForCurrentIOSVersion()
        }
        .modify {
            if #available(iOS 17.0, macOS 14.0, *) {
                $0.sensoryFeedback(.selection, trigger: self.selection)
            } else {
                $0
            }
        }
    }
}

struct CategorySection: View {
    let category: EmojiCategory
    var onSelect: (String) -> Void

    var body: some View {
        Section {
            ForEach(category.emojis, id: \.self) { emoji in
                EmojiCell(
                    emoji: emoji,
                    categoryType: category.type,
                    onSelect: { emojiString in
                        self.onSelect(emojiString)
                    }
                )
            }
        } header: {
            SectionHeader(title: category.categoryName)
                .id(category.type)
        }
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
        .sheet(isPresented: $isPresented) {
            EmojiPicker(
                selection: $selectedEmoji,
                isDismissAfterChoosing: true
            )
        }

        Text(selectedEmoji)
            .font(.largeTitle)
    }
}
