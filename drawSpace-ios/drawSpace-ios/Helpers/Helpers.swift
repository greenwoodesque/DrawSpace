//
//  Helpers.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/30/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import Foundation

protocol Named {
    var className: String { get }
    static var className: String { get }
}

extension NSObject: Named {
    var className: String {
        return type(of: self).className
    }

    static var className: String {
        return String(describing: self).components(separatedBy: ".").last ?? "n/a"
    }
}
