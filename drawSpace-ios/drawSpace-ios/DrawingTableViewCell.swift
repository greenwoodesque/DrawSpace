//
//  DrawingTableViewCell.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

protocol DrawingCellDelegate: class {
    func replay(drawing: Drawing)
    func delete(drawing: Drawing)
}

class DrawingTableViewCell: UITableViewCell {

    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var startedLabel: UILabel!
    @IBOutlet weak var drawingTimeLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
        
    var drawing: Drawing?
    weak var delegate: DrawingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(drawing: Drawing, delegate: DrawingCellDelegate) {
        self.drawing = drawing
        self.delegate = delegate
        imageHeightConstraint.constant = contentView.frame.width*drawing.aspectRatio
        startedLabel.text = DSDateFormatter.shared.startTimeFormatter(drawing: drawing)
        drawingTimeLabel.text = formatDrawingTime(drawing: drawing)
        getImage(drawing: drawing)
    }
    
    func getImage(drawing: Drawing) {
        DispatchQueue.global(qos: .background).async {
            Persistance.shared.retrieveImage(forKey: drawing.id, completion: { image in
                DispatchQueue.main.async { [weak self] in
                    self?.drawingImageView.image = image
                }
            })
        }
    }
    
    func formatDrawingTime(drawing: Drawing) -> String {
        guard let time = drawing.totalTime() else {
            return "NA"
        }
        let minutesString = time/60 > 1 ? "\(time/60) m " : ""
        let seconds = time.truncatingRemainder(dividingBy: 60)
        let secondsString = time > 1 ? "\(round(seconds)) s" : "1 s"
        return minutesString + secondsString
    }
    
    @IBAction func replayButton(_ sender: Any) {
        if let drawing = drawing {
            delegate?.replay(drawing: drawing)
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if let drawing = drawing {
            delegate?.delete(drawing: drawing)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
