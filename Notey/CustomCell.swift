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

class CustomCell: UITableViewCell {
    
    var delegate: Deletable?
    
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

    
}
