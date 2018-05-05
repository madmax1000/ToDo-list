//
//  ToDoCell.swift
//  ToDoList
//
//  Created by M.D. Bijkerk on 03-05-18.
//  Copyright © 2018 M.D. Bijkerk. All rights reserved.
//

import UIKit

// cell subclass
class ToDoCell: UITableViewCell {
    var delegate: ToDoCellDelegate?
    
    // create outlets
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped() {
        delegate?.checkmarkTapped(sender: self)
    }
}

// define a protocol with a method that passes the cell back to the delegate:
@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}
