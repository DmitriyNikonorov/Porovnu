//
//  EventView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import Combine

struct EventView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @Namespace private var namespace

    @State private var angle: Angle = .zero
    @State private var prevAngle: Angle = .zero
//    private let words: [String]
    private let viewModel: EventViewModel

    /// Массив для отображения всех связей сразу. Пока используется только одна связь
    @State private var connections: [WordConnection] = []

    @State var source: String = ""


    init(viewModel: EventViewModel) {
        self.viewModel = viewModel
//        words = viewModel.event.contributors.map(\.name)
    }

    var body: some View {
        ZStack {
            VStack {
                WordCircleView(
                    angle: $angle,
                    prevAngle: $prevAngle,
                    words: viewModel.words,
                    namespace: namespace,
                    onAngleChanged: updateSelectedWord,
                    connections: connections
                )
                .padding(.top, 8.0)
                Image(systemName: "arrow.up")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                Text(viewModel.selectedWord)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 60)
                Spacer()
            }
            VStack(alignment: .leading) {
                Spacer()
                Button {
                    navigationCoordinator.navigate(
                        to: .editSpending(
                            EditSpendingDto(
                                creditor: viewModel.selectContributor,
                                spending: nil,
                                contributors: viewModel.event.contributors,
                                callback: { spending in
                                    guard let spending else {
                                        return
                                    }

                                    viewModel.saveSpending(spending)

                                }
                            )
                        )
                    )
                } label: {
                    Text("Добавить трату")
                }
            }
            .padding(.bottom, 90)
        }
        .background(Color.appColor(.backgroundSecondary))
        .navigationBar(
            for: .event(title: viewModel.event.name),
            leadingButtonAction: navigationCoordinator.navigateToRoot,
            trailingButtonAction: {
                navigationCoordinator.navigate(to: .editEvent(EditEventDto(event: viewModel.event, onSave: { event in
                    guard let event else {
                        return
                    }
                    viewModel.updateEvent(event: event)

                })))
            }
        )
    }
}

// MARK: - Private

private extension EventView {

    func updateSelectedWord() {
        let rotationDegrees = angle.degrees.truncatingRemainder(dividingBy: 360)
        let normalizedRotation = rotationDegrees >= 0 ? rotationDegrees : rotationDegrees + 360
        let pointerAngle: Double = 270

        var bestIndex = 0
        var smallestDifference = Double.infinity

        for index in 0..<viewModel.words.count {
            let wordOffset = Double(index) / Double(viewModel.words.count) * 360
            var globalWordAngle = (normalizedRotation + wordOffset).truncatingRemainder(dividingBy: 360)
            if globalWordAngle < 0 { globalWordAngle += 360 }

            var difference = abs(globalWordAngle - pointerAngle)
            difference = min(difference, 360 - difference)

            if difference < smallestDifference {
                smallestDifference = difference
                bestIndex = index
            }
        }

        guard viewModel.selectedWord != viewModel.words[bestIndex] else {
            return
        }
        viewModel.selectedWord = viewModel.words[bestIndex]

        let shuffled = viewModel.words.shuffled()
        guard shuffled.count >= 3 else { return }

        let source = viewModel.selectedWord
        let targets = Array(shuffled[1...2])

        connections = [
            WordConnection(sourceWord: source, targetWords: targets)
        ]
    }
}

// MARK: - Gesture

struct RotateGesture: Gesture {
    @Binding var angle: Angle
    @Binding var prevAngle: Angle
    let size: CGSize
    let onAngleChanged: () -> Void

    var body: some Gesture {
        DragGesture()
            .onChanged { value in
                let location = value.location
                let startLocation = value.startLocation
                let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)

                let locationAngle = atan2(location.x - center.x,
                                          center.y - location.y)
                let startLocationAngle = atan2(startLocation.x - center.x,
                                               center.y - startLocation.y)

                var delta = locationAngle - startLocationAngle

                if delta > .pi {
                    delta -= .pi * 2
                } else if delta < -.pi {
                    delta += .pi * 2
                }

                angle = prevAngle + Angle(radians: Double(delta))
                onAngleChanged()
            }
            .onEnded { _ in
                prevAngle = angle
                onAngleChanged()
            }
    }
}
