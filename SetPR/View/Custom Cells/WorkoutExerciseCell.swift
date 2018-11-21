//
//  WorkoutExerciseCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/9/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class WorkoutExerciseCell: UITableViewCell {

    // MARK: - Outlets
   
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberButton.layer.cornerRadius = numberButton.frame.size.width / 2
        numberButton.layer.masksToBounds = true
        numberButton.layer.borderWidth = 1
        numberButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
