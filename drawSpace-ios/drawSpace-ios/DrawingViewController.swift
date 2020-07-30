//
//  DrawingViewController.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import Foundation

import UIKit

protocol DrawPadDelegate: class {
    func drawingSaved()
}

class DrawPadViewController: UIViewController {
    
    var strokes: [Stroke] = []
    var currentStroke: Stroke?
    var lastPoint = CGPoint.zero
    var continuous = false
    let drawView = DrawView()
    weak var delegate: DrawPadDelegate?
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDrawing))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        drawView.frame = view.frame
        view.addSubview(drawView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else {return}
        let color = Stroke.Color(red: 100, green: 0, blue: 0)
        currentStroke = Stroke(points: [touchPoint], startTime: Date(), endTime: Date(), color: color)
        lastPoint = touchPoint
        drawView.currentStroke = currentStroke
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else {return}

        currentStroke?.points.append(touchPoint)
        drawView.currentStroke = currentStroke
        lastPoint = touchPoint
        continuous = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentStroke?.endTime = Date()
        continuous = false
        if let current = currentStroke {
            strokes.append(current)
        }
        drawView.strokes = strokes
        currentStroke = nil
    }
    
    @objc func saveDrawing() {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        let aspectRatio = drawView.frame.height/drawView.frame.width
        let drawing = Drawing(strokes: strokes, aspectRatio: aspectRatio)
        do {
            try Persistance.shared.save(drawing: drawing, image: image)
            delegate?.drawingSaved()
        } catch {
            print("Error saving drawing.")
        }
    }
}
