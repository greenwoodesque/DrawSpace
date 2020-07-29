//
//  Drawing.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/28/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import Foundation
import UIKit

struct Drawing: Codable {
    var id: UInt64
    var strokes: [Stroke]
}

struct Stroke: Codable {
    var points: [CGPoint]
    var startTime: Date
    var endTime: Date
    var color: Color
    
    struct Color: Codable {
        var red: Int
        var green: Int
        var blue: Int
    }
}

extension Stroke {
    func draw() {
        guard !self.points.isEmpty else {return}
        if self.points.count == 1 {
            draw(from: self.points[0], to: self.points[0])
        }
        else {
            for i in 1...self.points.count-1 {
                draw(from: self.points[i-1], to: self.points[i])
            }
        }
    }
    
    private func draw(from: CGPoint, to: CGPoint) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        context.setLineWidth(5)
        context.setStrokeColor(UIColor.red.cgColor)
        context.move(to: from)
        context.addLine(to: to)
        context.closePath()
        context.drawPath(using: .fillStroke)
    }
}
