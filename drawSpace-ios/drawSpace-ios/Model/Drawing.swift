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
    var id: String
    var strokes: [Stroke]
    var aspectRatio: CGFloat
    
    init(strokes: [Stroke], aspectRatio: CGFloat) {
        self.strokes = strokes
        self.aspectRatio = aspectRatio
        id = UUID().uuidString
    }
}

extension Drawing {
    func startTime() -> Date? {
        guard let firstStroke = strokes.first else { return nil }
        return firstStroke.startTime
    }
    
    func totalTime() -> TimeInterval? {
        guard let firstStroke = strokes.first,
            let lastStroke = strokes.last else { return nil }
        return lastStroke.endTime.timeIntervalSince(firstStroke.startTime)
    }
}
