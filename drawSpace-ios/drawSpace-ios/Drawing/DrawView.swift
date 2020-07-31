//
//  DrawView.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var strokes: [Stroke]? {
        didSet {
            setNeedsDisplay()
        }
    }
    var currentStroke: Stroke? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.drawsAsynchronously = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawView {
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        guard let strokes = strokes else {
            return
        }
        for stroke in strokes {
            stroke.draw()
        }
        if let currentStroke = currentStroke {
            currentStroke.draw()
        }
    }
}
