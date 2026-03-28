//
//  ToastView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 25.03.2026.
//

import SwiftUI

struct ToastView: View {
    struct ToastData {
        var title: String
        var message: String
    }

    @Binding var showToast: Bool
    let toastData: ToastData
    @State private var toastTask: Task<Void, Error>?

    var body: some View {
        VStack {
            HStack {
                AppImages.checkmark.image
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(toastData.title))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(LocalizedStringKey(toastData.message))
                        .font(.callout)
                        .opacity(0.9)

                }
                Spacer()
            }
            .padding(10)


            .foregroundColor(Color.appColor(.text))
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appColor(.orangeBrand).opacity(0.9),
                                Color.appColor(.orangeBrand).opacity(0.95)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 1.0)

            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.appColor(.background).opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.appColor(.background).opacity(0.1), radius: 10, y: 2)

            Spacer()
        }
        .padding()
        .opacity(showToast ? 1.0 : 0)
        .transition(.opacity)
        .onAppear {
            toastTask = Task {
                try await Task.sleep(nanoseconds: 2_500_000_000)
                await MainActor.run {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
        .onDisappear {
            toastTask?.cancel()
        }
        .onTapGesture {
            toastTask?.cancel()
            withAnimation {
                showToast = false
            }
        }
    }
}
