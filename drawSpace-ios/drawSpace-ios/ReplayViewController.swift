//
//  ReplayViewController.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class ReplayViewController: UIViewController {
    
    var strokes: [Stroke]!
    var replayView = ReplayView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replayView.frame = view.frame
        view.addSubview(replayView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        replayView.strokes = strokes
    }
}

extension ReplayViewController {
    static func make(strokes: [Stroke]) -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("`\(className)` not found in storyboard.'")
        }
        vc.strokes = strokes
        return vc
    }
}
