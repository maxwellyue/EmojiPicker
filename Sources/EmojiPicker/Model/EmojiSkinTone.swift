//
//  EmojiSkinTone.swift
//  EmojiPicker
//
//  Created by yueyuemax on 2025/11/1.
//
import Foundation

/// This enumeration allows you to determine which skin tones can be set for `Emoji`.
public enum EmojiSkinTone: Int, CaseIterable {
    case none = 1
    case light = 2
    case mediumLight = 3
    case medium = 4
    case mediumDark = 5
    case dark = 6

    /// Hex value for the skin tone.
    public var skinKey: Int? {
        switch self {
        case .none:
            return nil
        case .light:
            return 0x1F3FB
        case .mediumLight:
            return 0x1F3FC
        case .medium:
            return 0x1F3FD
        case .mediumDark:
            return 0x1F3FE
        case .dark:
            return 0x1F3FF
        }
    }
}
