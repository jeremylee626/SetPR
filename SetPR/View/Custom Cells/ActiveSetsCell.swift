//
//  ActiveSetsCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/19/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class ActiveSetsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var repsTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    @IBOutlet weak var restTimerLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusButton.layer.cornerRadius = statusButton.bounds.size.width / 2
        statusButton.clipsToBounds = true
        statusButton.layer.borderWidth = 1.0
        statusButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }

    
}
