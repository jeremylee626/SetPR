//
//  TextFieldExtensions.swift
//  SetPR
//
//  Created by Jeremy Lee on 11/16/18.
//  Copyright © 2018 Jeremy Lee. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createToolbar(chosenTextField: UITextField) {
        
        // Create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        // Create done button and flexible space items
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.toolbarDoneButtonPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Add button and flexible space to toolbar
        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)
        
        // Add toolbar to text field
        chosenTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func toolbarDoneButtonPressed() {
        view.endEditing(true)
    }
    
}
