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

import Combine
import SwiftUI

/// View model for SwiftUI-based emoji picker.
@MainActor
public class EmojiPickerViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var selectedEmoji: Emoji?
    @Published public var selectedCategory: EmojiCategoryType? = .frequentlyUsed

    // MARK: - Public Properties
    
    public var emojiCategories: [EmojiCategory] {
        allEmojiCategories.filter { !$0.emojis.isEmpty }
    }

    // MARK: - Private Properties
    
    /// All emoji categories.
    private var allEmojiCategories: [EmojiCategory] = []
    private let unicodeManager: UnicodeManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    public init(unicodeManager: UnicodeManagerProtocol = UnicodeManager()) {
        self.unicodeManager = unicodeManager
        self.allEmojiCategories = unicodeManager.getEmojisForCurrentIOSVersion()
        
        // Increment usage count when emoji is selected
        $selectedEmoji
            .compactMap { $0 }
            .sink { emoji in
                emoji.incrementUsageCount()
            }
            .store(in: &cancellables)
    }

    public func updateEmojiSkinTone(_ skinTone: EmojiSkinTone, for emoji: Emoji, in categoryType: EmojiCategoryType) {
        guard let allCategoriesIndex = allEmojiCategories.firstIndex(where: { $0.type == categoryType }),
              let emojiIndex = allEmojiCategories[allCategoriesIndex].emojis.firstIndex(where: {
                  $0.emojiKeys == emoji.emojiKeys
              })
        else {
            return
        }
        
        // 保存皮肤色调到 UserDefaults
        allEmojiCategories[allCategoriesIndex].emojis[emojiIndex].set(skinToneRawValue: skinTone.rawValue)
        
        // 获取更新后的 emoji（此时它应该从 UserDefaults 读取正确的皮肤色调）
        let updatedEmoji = allEmojiCategories[allCategoriesIndex].emojis[emojiIndex]
        selectedEmoji = updatedEmoji
        
        // 触发视图刷新，确保所有 EmojiCell 都会重新评估
        objectWillChange.send()
    }
}
