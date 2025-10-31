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

// MARK: - Section Offset Data

struct SectionOffsetData: Equatable {
    let categoryIndex: Int
    let offset: CGFloat
}

// MARK: - Preference Key for Section Offset

struct SectionOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [SectionOffsetData] = []

    static func reduce(value: inout [SectionOffsetData], nextValue: () -> [SectionOffsetData]) {
        let next = nextValue()
        // 如果已经有相同 categoryIndex 的数据，更新它；否则添加新的
        for newData in next {
            if let index = value.firstIndex(where: { $0.categoryIndex == newData.categoryIndex }) {
                value[index] = newData
            } else {
                value.append(newData)
            }
        }
    }
}

// MARK: - Section Scroll Tracker View

struct SectionScrollTracker: ViewModifier {
    let categoryIndex: Int

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: SectionOffsetPreferenceKey.self,
                            value: [
                                SectionOffsetData(
                                    categoryIndex: categoryIndex,
                                    offset: geometry.frame(in: .global).minY
                                )
                            ]
                        )
                }
            )
    }
}

extension View {
    func sectionScrollTracker(categoryIndex: Int) -> some View {
        modifier(SectionScrollTracker(categoryIndex: categoryIndex))
    }
}
