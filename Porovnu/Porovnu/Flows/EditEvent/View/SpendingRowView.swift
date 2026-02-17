//
//  SpendingRowView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 17.02.2026.
//

import SwiftUI

struct SpendingRowView: View {
    let spending: Spending
    let contributor: Contributor
    var onAction: (EditViewAction) -> Void

    var body: some View {
        HStack {
            Text(spending.name)
                .foregroundStyle(Color.appColor(.textSecondary))
                .font(.system(size: 16, weight: .regular))
            Spacer()
            Text(String.amountString(amount: spending.totalAmount))
                .foregroundStyle(Color.appColor(.textSecondary))
                .font(.system(size: 16, weight: .regular))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            onAction(.onTap(spending: spending, contributor: contributor))
        }
        .contextMenu {
            Button(role: .destructive) {
                onAction(.onDelete(spending: spending, contributor: contributor))
            } label: {
                Label("Удалить трату", systemImage: AppImages.trash.sring)
            }
        }
    }
}

