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
    var width: CGFloat
    
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
            draw(from: points[0], to: points[0], color: getCGColor(), width: width)
        }
        else {
            for i in 1...points.count-1 {
                draw(from: points[i-1], to: points[i], color: getCGColor(), width: width)
            }
        }
    }
    
    private func draw(from: CGPoint, to: CGPoint, color: CGColor, width: CGFloat) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        context.setLineWidth(width)
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
