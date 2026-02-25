//
//  RowView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 13.02.2026.
//

import SwiftUI

struct RowWordCircleView: View {
    let word: String
    let width: CGFloat

    var body: some View {
        HStack {
            Text(word)
                .font(.caption)
                .fontWeight(.bold)
                .fixedSize()
            Spacer()
        }
    }
}
