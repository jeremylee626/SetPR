//
//  SetsPlanningCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/15/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class SetsPlanningCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var setNumberButton: UIButton!
    @IBOutlet weak var repsTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    @IBOutlet weak var intensityTextField: CustomTextField!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNumberButton.layer.cornerRadius = setNumberButton.bounds.size.width / 2
        setNumberButton.clipsToBounds = true

        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
