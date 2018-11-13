//
//  ExerciseBankCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/6/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class ExerciseBankCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = super.bounds.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
