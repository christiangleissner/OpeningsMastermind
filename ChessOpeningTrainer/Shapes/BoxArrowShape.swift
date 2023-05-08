//
//  BoxArrowShape.swift
//  ChessOpeningTrainer
//
//  Created by Christian Gleißner on 08.05.23.
//

import Foundation
import SwiftUI

struct BoxArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 5
        return Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))

            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
            
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.midX + 10, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + 10))
            path.addLine(to: CGPoint(x: rect.midX - 10, y: rect.maxY))
            
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}


struct BoxArrowShape_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
