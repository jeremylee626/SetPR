//
//  AddCell.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/7/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class AddCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addButton.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
