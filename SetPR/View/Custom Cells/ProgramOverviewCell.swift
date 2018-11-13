//
//  ProgramOverviewCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/12/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class ProgramOverviewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var weeksNoLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activateButton.layer.cornerRadius = activateButton.frame.size.width / 2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
