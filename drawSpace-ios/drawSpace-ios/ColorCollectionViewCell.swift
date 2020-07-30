//
//  ColorCollectionViewCell.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/30/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
}

