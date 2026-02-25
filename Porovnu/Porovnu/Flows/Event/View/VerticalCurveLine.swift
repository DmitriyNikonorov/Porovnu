//
//  VerticalCurveLine.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 13.02.2026.
//

import SwiftUI

struct VerticalCurveLine: Shape {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let index: Int
    let totalCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Вычисляем контрольные точки для красивой кривой
        let midX = (startPoint.x + endPoint.x) / 2
        let offset: CGFloat = 50 + CGFloat(index) * 20

        let control1 = CGPoint(
            x: midX - offset,
            y: startPoint.y + (endPoint.y - startPoint.y) * 0.25
        )

        let control2 = CGPoint(
            x: midX + offset,
            y: endPoint.y - (endPoint.y - startPoint.y) * 0.25
        )

        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)

        return path
    }
}
