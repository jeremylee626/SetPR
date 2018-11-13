//
//  ProgramCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/10/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class ProgramCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workoutButton: UIButton!
    @IBOutlet weak var nutritionButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let buttons = [workoutButton, nutritionButton, sleepButton]
        for button in buttons {
            button!.layer.cornerRadius = button!.frame.size.width / 2
            button!.layer.masksToBounds = true
            button!.layer.borderWidth = 1
            button!.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
