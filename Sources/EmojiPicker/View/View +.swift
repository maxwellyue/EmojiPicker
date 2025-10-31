//
//  View +.swift
//  EmojiPicker
//
//  Created by yueyuemax on 2025/10/31.
//
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<T>(_ condition: Bool, apply: (Self) -> T) -> some View where T: View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }

    @ViewBuilder
    func applyScrollTargetLayout() -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            self.scrollTargetLayout()
        } else {
            self
        }
    }
}
