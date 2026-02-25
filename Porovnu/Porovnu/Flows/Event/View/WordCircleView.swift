//
//  WordCircleView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 13.02.2026.
//

import SwiftUI

struct WordCircleView: View {

    private let namespace: Namespace.ID
    @Binding private var angle: Angle
    @Binding private var prevAngle: Angle

    let words: [String]
    let onAngleChanged: () -> Void

    let connections: [WordConnection]? // Опциональные связи между именами

    // Инициализатор для работы с @Binding из родителя
    init(angle: Binding<Angle>? = nil,
         prevAngle: Binding<Angle>? = nil,
         words: [String],
         namespace: Namespace.ID,
         onAngleChanged: @escaping () -> Void,
         connections: [WordConnection]? = nil
    ) {
        self._angle = angle ?? .constant(.zero)
        self._prevAngle = prevAngle ?? .constant(.zero)
        self.words = words
        self.namespace = namespace
        self.onAngleChanged = onAngleChanged
        self.connections = connections
    }

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let radius = side / 2
            let center = CGPoint(x: side / 2, y: side / 2)

            ZStack {
                Color.clear

                // Линии связей
                if let connections = connections {
                    ForEach(connections) { connection in

                        if let sourceIndex = words.firstIndex(of: connection.sourceWord) {
                            let sourceAngle = calculateAngle(for: sourceIndex)
                            let sourcePoint = pointOnCircle(angle: sourceAngle + angle, radius: radius, center: center)

                            ForEach(Array(connection.targetWords.enumerated()), id: \.offset) { index, targetWord in

                                if let targetIndex = words.firstIndex(of: targetWord) {
                                    let targetAngle = calculateAngle(for: targetIndex)
                                    let targetPoint = pointOnCircle(angle: targetAngle + angle, radius: radius, center: center)

                                    /// Крривая линия
                                    VerticalCurveLine(
                                        startPoint: sourcePoint,
                                        endPoint: targetPoint,
                                        index: index,
                                        totalCount: connection.targetWords.count
                                    )
                                    .stroke(Color.appColor(.orangeBrand), lineWidth: 0.5)
                                    .opacity(0.5)
                                }
                            }
                        }
                    }
                }

                ZStack {
                    ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                        RowWordCircleView(word: word, width: CGFloat(radius))
                            .matchedGeometryEffect(id: index, in: namespace)
                            .frame(width: side, height: side)
                            .foregroundColor(index % 2 == 0 ? Color.appColor(.blueBrand) : Color.appColor(.orangeBrand))
                            .rotationEffect(.degrees(Double(index) / Double(words.count)) * 360)
                        // Видимо здесь размещать вьюху с линией от выбранного участника до его должников
                    }
                    .rotationEffect(angle)
                }
                .frame(width: side, height: side)
                .gesture(
                    RotateGesture(
                        angle: $angle,
                        prevAngle: $prevAngle,
                        size: CGSize(width: side, height: side),
                        onAngleChanged: onAngleChanged
                    )
                )
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .aspectRatio(1, contentMode: .fit) // Круг всегда квадратный
    }


    private func calculateAngle(for index: Int) -> Angle {
        .degrees(Double(index) / Double(words.count) * 360 - 180)
    }

    private func pointOnCircle(angle: Angle, radius: CGFloat, center: CGPoint) -> CGPoint {
        CGPoint(
            x: center.x + radius * cos(CGFloat(angle.radians)),
            y: center.y + radius * sin(CGFloat(angle.radians))
        )
    }

//    private func sourcePointOnCircle(angle: Angle, radius: CGFloat, center: CGPoint, word: String) -> CGPoint {
//        let font = UIFont.systemFont(ofSize: 12)
//
//        let attributedString = NSAttributedString(string: word, attributes: [.font: font])
//        let textSize = attributedString.size()
//
//        // Расстояние по горизонтали
//        let stringWidth = textSize.width
//
//
//        return CGPoint(
//            x: center.x + radius * cos(CGFloat(angle.radians)),
//            y: center.y + radius * sin(CGFloat(angle.radians)) - stringWidth
//        )
//    }
}

