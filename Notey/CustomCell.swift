//
//  CustomCellTableViewCell.swift
//  Notey
//
//  Created by Antonija Pek on 15/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

protocol Deletable {
    func deleteButtonPressed(cell: CustomCell)
}

protocol NotesTableDelegate {
    // indicates that the given item has been deleted
    func noteDeleted(note: Notes)
}

class CustomCell: UITableViewCell {
    
    var delegate: Deletable?
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    // The object that acts as delegate for this cell.
    var delegateForNotesTableDelegate: NotesTableDelegate?
    // The item that this cell renders.
    var note: Notes?
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSeparator: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.deleteButtonPressed(self)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add a pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
        if deleteOnDragRelease {
            if delegateForNotesTableDelegate != nil && note != nil {
                // notify the delegate that this item should be deleted
                delegateForNotesTableDelegate!.noteDeleted(note!)
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    

    
}
