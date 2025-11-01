// The MIT License (MIT)
//
// Copyright © 2022 Ivan Izyumkin
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
#elseif os(macOS)
import AppKit
#endif

/// 主 Emoji 选择器视图
public struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss

    @Binding public var selectedEmoji: String
    public var isDismissAfterChoosing: Bool

    public init(selectedEmoji: Binding<String>, isDismissAfterChoosing: Bool = true) {
        self._selectedEmoji = selectedEmoji
        self.isDismissAfterChoosing = isDismissAfterChoosing
    }

    @StateObject private var viewModel = EmojiPickerViewModel()

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: .infinity), spacing: 12)], spacing: 12) {
                            ForEach(viewModel.emojiCategories, id: \.type) { category in
                                Section {
                                    ForEach(category.emojis, id: \.self) { emoji in
                                        EmojiCell(
                                            emoji: emoji,
                                            categoryType: category.type,
                                            viewModel: viewModel
                                        )
                                        // 使用 category.type 和 emojiKeys 作为唯一 id
                                        .id("\(category.type.rawValue)-\(emoji.emojiKeys)")
                                    }
                                } header: {
                                    SectionHeader(title: category.categoryName)
                                }
                                // 配合 scrollTo 和 scrollPosition
                                .id(category.type)
                            }
                        }
                        .padding(.horizontal, 12)
                        .applyScrollTargetLayout()
                    }
                    .modify {
                        if #available(iOS 17.0, macOS 14.0, *) {
                            $0.scrollPosition(id: $viewModel.selectedCategory, anchor: .top)
                        } else {
                            $0.onChange(of: viewModel.selectedCategory) { newType in
                                withAnimation {
                                    scrollProxy.scrollTo(newType, anchor: .top)
                                }
                            }
                        }
                    }
                }

                Divider()

                CategoryBar(
                    categories: viewModel.emojiCategories,
                    selectedCategory: $viewModel.selectedCategory
                )
            }
            .navigationTitle("Emoji")
            #if os(iOS) || targetEnvironment(macCatalyst)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
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
                .background(Color.pickerBackground)
        }
        .onChange(of: viewModel.selectedEmoji) { newValue in
            if let emoji = newValue {
                selectedEmoji = emoji.string
                if isDismissAfterChoosing {
                    dismiss()
                }
            }
        }
        .modify {
            if #available(iOS 17.0, macOS 14.0, *) {
                $0.sensoryFeedback(.selection, trigger: self.selectedEmoji)
            } else {
                $0
            }
        }
    }
}

// MARK: - Platform Color Extension

extension Color {
    static var pickerBackground: Color {
        #if os(macOS)
        return Color(nsColor: .controlBackgroundColor)
        #else
        return Color(uiColor: .systemGroupedBackground)
        #endif
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var isPresented = true
    @Previewable @State var selectedEmoji = ""

    Button(action: {
        isPresented.toggle()
    }) {
        Text(verbatim: "Show Emoji Picker :  \(selectedEmoji)")
    }
    .buttonStyle(.borderedProminent)
    .padding()
    .sheet(isPresented: $isPresented) {
        EmojiPicker(
            selectedEmoji: $selectedEmoji,
            isDismissAfterChoosing: true
        )
    }
}
