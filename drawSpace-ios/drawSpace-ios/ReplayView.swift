//
//  ReplayView.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/30/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class ReplayView: UIView {
    let queue = DispatchQueue(label: "replayQueue")
    let opqueue = OperationQueue(
    )
    var strokes: [Stroke]? {
        didSet {
            setNeedsDisplay()
        }
    }
}

extension ReplayView {
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        guard let strokes = strokes, !strokes.isEmpty else {return}
        replay(strokes[0])
        var delay: CFTimeInterval = 0
        for i in 1..<strokes.count {
            //Delay start of animation until previous stroke has completed
            let drawTime = strokes[i-1].endTime.timeIntervalSince(strokes[i-1].startTime)
            //Adding a small delay between strokes
            delay += drawTime + 0.4
            replay(strokes[i], delay: delay)
         }
    }
    
    func replay(_ stroke: Stroke, delay: CFTimeInterval? = nil) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(rect: CGRect(origin: stroke.points[0], size: .zero))
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.fillRule = .evenOdd
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        if stroke.points.count == 1 {
            path.addLine(to: stroke.points[0])
        } else {
            for i in 1...stroke.points.count-1 {
                path.addLine(to: stroke.points[i])
            }
        }
        shapeLayer.path = path.cgPath
       
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = stroke.endTime.timeIntervalSince(stroke.startTime)
        animation.fillMode = CAMediaTimingFillMode.backwards
                    animation.isRemovedOnCompletion = false
        if let delay = delay {
            let layerTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            animation.beginTime = layerTime+delay
        }

        layer.addSublayer(shapeLayer)
        shapeLayer.add(animation, forKey: nil)
    }
}
