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
        reload()
    }

    func reload() {
        Persistance.shared.getAllDrawings(success: { drawings in
            self.drawings = drawings
            tableView.reloadData()
            if drawings.count == 0 {
                tableView.backgroundView = UINib(nibName: "EmptyTableView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
                tableView.backgroundView?.isHidden = false
            }
        }, failure: { error in
            print("ERROR RETRIEVING DRAWINGS: \(error)")
        })
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
                print("Remember to create error alert.")
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
