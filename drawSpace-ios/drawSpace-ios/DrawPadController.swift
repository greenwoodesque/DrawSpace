//
//  DrawPadController.swift
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
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var strokes: [Stroke] = []
    var currentStroke: Stroke?
    var lastPoint = CGPoint.zero
    var continuous = false
    let drawView = DrawView()
    weak var delegate: DrawPadDelegate?
    
    let colors = Styles.colors
    var currentColor: UIColor = .black
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDrawing))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false
//        drawView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        NSLayoutConstraint.activate([
            drawView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            drawView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            drawView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: 0),
            drawView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        let squareSide = colorCollectionView.frame.height
        let layout = colorCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: squareSide, height: squareSide)
        colorCollectionView.collectionViewLayout = layout
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else {return}
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        currentColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let color = Stroke.Color(red: red, green: green, blue: blue)
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

extension DrawPadViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentColor = colors[indexPath.row]
    }
}

extension DrawPadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell else {
            fatalError("Wrong collectionView cell.")
        }
        cell.configure(with: colors[indexPath.row])
        return cell
    }
}

extension DrawPadViewController {
    static func make(delegate: DrawPadDelegate) -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("`\(className)` not found in storyboard.")
        }
        vc.delegate = delegate
        return vc
    }
}
