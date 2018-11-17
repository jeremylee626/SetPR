//
//  AddItemFooterView.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/16/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

class AddItemFooterView: UIView {

    @IBOutlet weak var addItemButton: UIButton!
    
    
    override func awakeFromNib() {
        addItemButton.layer.cornerRadius = 10.0
    }

}
