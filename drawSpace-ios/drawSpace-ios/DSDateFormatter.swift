//
//  DSDateFormatter.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import Foundation

class DSDateFormatter {
    static let shared = DSDateFormatter()
    
    let df = DateFormatter()
    
    func startTimeFormatter(drawing: Drawing) -> String {
        guard let date = drawing.startTime() else {
            return "NA"
        }
        df.dateFormat =  "MMM dd, hh:mm a"
        df.timeZone = TimeZone.current
        return df.string(from: date)
    }
}
