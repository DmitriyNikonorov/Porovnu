//
//  UnevenRoundedRectangle+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 21.02.2026.
//

import SwiftUI

extension UnevenRoundedRectangle {
    init(corners: Corners) {
        switch corners {
            case .top(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: .zero, bottomTrailing: .zero, topTrailing: value))

        case .bottom(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: .zero, bottomLeading: value, bottomTrailing: value, topTrailing: .zero))

        case .leading(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: value, bottomTrailing: .zero, topTrailing: .zero))

        case .trailing(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: .zero, bottomLeading: .zero, bottomTrailing: value, topTrailing: value))

        case .all(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: value, bottomTrailing: value, topTrailing: value))
        }
    }
}
