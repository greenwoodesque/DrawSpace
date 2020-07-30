//
//  Stroke.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

struct Stroke: Codable {
    var points: [CGPoint]
    var startTime: Date
    var endTime: Date
    var color: Color
    
    struct Color: Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
    }
}

extension Stroke {
    func draw() {
        guard !self.points.isEmpty else {return}
        if self.points.count == 1 {
            draw(from: self.points[0], to: self.points[0], color: getCGColor())
        }
        else {
            for i in 1...self.points.count-1 {
                draw(from: self.points[i-1], to: self.points[i], color: getCGColor())
            }
        }
    }
    
    private func draw(from: CGPoint, to: CGPoint, color: CGColor) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        context.setLineWidth(5)
        context.setStrokeColor(color)
        context.move(to: from)
        context.addLine(to: to)
        context.closePath()
        context.drawPath(using: .fillStroke)
    }
    
    func getCGColor() -> CGColor{
        let uic = UIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1)
        return uic.cgColor
    }
}
