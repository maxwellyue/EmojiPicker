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

import Foundation
#if os(iOS)
import UIKit
#endif

/// Protocol for the `UnicodeManager`.
public protocol UnicodeManagerProtocol {
    /// Returns categories with filtered emoji arrays that are available in the current version of iOS.
    func getEmojisForCurrentIOSVersion() -> [EmojiCategory]
}

extension EmojiCategoryType {
    var emojiCategoryTitle: String {
        String(localized: String.LocalizationValue(self.localizeKey), bundle: .module)
    }
}

/// The class is responsible for getting a relevant set of emojis for iOS version.
public final class UnicodeManager: UnicodeManagerProtocol {
    
    /// The maximum number of frequently used emojis to include in the `frequentlyUsed` category.
    public let maxFrequentlyUsedEmojisCount: Int
    
    // MARK: - Initializers
    
    public init(maxFrequentlyUsedEmojis: Int = 30) {
        self.maxFrequentlyUsedEmojisCount = maxFrequentlyUsedEmojis
    }
    
    // MARK: - Public Methods
    
    /// Returns all emojis available for the current device's iOS version.
    public func getEmojisForCurrentIOSVersion() -> [EmojiCategory] {
        let frequentlyUsedEmojis: EmojiCategory = .init(
            type: .frequentlyUsed,
            emojis: getFrequentlyUsedEmojis()
        )
        return [frequentlyUsedEmojis] + Self.defaultEmojis
    }
    
    // MARK: - Private Methods

    /// Returns the top n (`maxFrequentlyUsedEmojis`) emojis by usage, for emojis with a `usageCount` > 0.
    private func getFrequentlyUsedEmojis() -> [Emoji] {
        Array(
            Self.defaultEmojis
                .lazy
                .flatMap({ $0.emojis })
                .filter({ $0.usageCount > 0 })
                .sorted(by: { lhs, rhs in
                    let (aUsage, bUsage) = (lhs.usage, rhs.usage)
                    guard aUsage.count != bUsage.count else {
                        // Break ties with most recent usage
                        return lhs.lastUsage > rhs.lastUsage
                    }
                    return aUsage.count > bUsage.count
                })
                .prefix(maxFrequentlyUsedEmojisCount)
        )
    }

    // MARK: - Private Properties
    
    /// The maximum available emoji version for the current OS version.
    private static let maxCurrentAvailableEmojiVersion: Double = {
        #if os(iOS)
        let currentVersion = (UIDevice.current.systemVersion as NSString).floatValue
        switch currentVersion {
        case 16.4...:
            return 15.0
        case 15.4..<16.4:
            return 14.0
        case 14.5..<15.4:
            return 13.1
        case 14.2..<14.5:
            return 13.0
        case 13.2..<14.2:
            return 12.0
        default:
            return 11.0
        }
        #elseif os(macOS)
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        switch osVersion.majorVersion {
        case 14...:
            return 15.1  // macOS 14+ (Sonoma)
        case 13:
            return 15.0  // macOS 13 (Ventura)
        case 12:
            return 14.0  // macOS 12 (Monterey)
        default:
            return 13.1
        }
        #else
        return 15.0
        #endif
    }()

    /// Filters emojis based on the current platform's supported emoji version.
    static func filterEmojis(in category: EmojiCategory) -> EmojiCategory {
        var filtered = category
        filtered.emojis.removeAll { $0.version > Self.maxCurrentAvailableEmojiVersion }
        return filtered
    }

    static let defaultEmojis: [EmojiCategory] = [
        filterEmojis(in: EmojiDefinitions.peopleEmojis),
        filterEmojis(in: EmojiDefinitions.natureEmojis),
        filterEmojis(in: EmojiDefinitions.foodAndDrinkEmojis),
        filterEmojis(in: EmojiDefinitions.activityEmojis),
        filterEmojis(in: EmojiDefinitions.travelAndPlacesEmojis),
        filterEmojis(in: EmojiDefinitions.objectEmojis),
        filterEmojis(in: EmojiDefinitions.symbolEmojis),
        filterEmojis(in: EmojiDefinitions.flagEmojis)
    ]
}
