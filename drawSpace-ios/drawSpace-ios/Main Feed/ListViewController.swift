//
//  ListViewController.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var drawings: [Drawing] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(launchDrawPad))
            title = "DrawSpace"
            navigationItem.rightBarButtonItem = composeButton
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = UINib(nibName: "EmptyTableView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        tableView.backgroundView?.isHidden = false
        reload()
    }

    func reload() {
        Persistance.shared.getAllDrawings(success: { drawings in
            self.drawings = drawings
            tableView.reloadData()
        }, failure: { error in
            showErrorAlert(error)
        })
    }
    
    func showErrorAlert(_ error: Error) {
        let controller = UIAlertController(title: "Sorry! An error occured.", message: "This is what it was, technically: \(error). Please try again!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true)
    }
    
    @objc func launchDrawPad() {
        let vc = DrawPadViewController.make(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "drawingCell") as? DrawingTableViewCell else {
            fatalError("wrong table cell")
        }
        cell.configure(drawing: drawings[indexPath.row], delegate: self)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageWidth = tableView.frame.width - Styles.infoViewWidth
        return imageWidth * drawings[indexPath.row].aspectRatio + 4
    }
}

extension ListViewController: DrawingCellDelegate {
    func replay(drawing: Drawing) {
        let vc = ReplayViewController.make(strokes: drawing.strokes)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func delete(drawing: Drawing) {
        let controller = UIAlertController(title: "Delete drawing?", message: "Are you sure you want to delete this drawing?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        controller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            do {
                try Persistance.shared.delete(drawing: drawing)
                self.reload()
            } catch {
                self.showErrorAlert(error)
            }
        }))
        present(controller, animated: true)
    }
}

extension ListViewController: DrawPadDelegate {
    func drawingSaved() {
        reload()
        navigationController?.popViewController(animated: true)
    }
}
