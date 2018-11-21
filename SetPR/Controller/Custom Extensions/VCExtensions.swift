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
    
    func createHeaderViewFromNib(nibName: String, height: CGFloat) -> UIView {
        // Create UIView for header
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        
        // Load custom header view
        if let setsHeaderView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? SetsHeaderView {
            
            // Add custom view to headerView
            headerView.addSubview(setsHeaderView)
            setsHeaderView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height)
        }
        
        return headerView
    }
    
    func createAddFooterViewFromNib(nibName: String, height: CGFloat, buttonTitle: String) -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        
        if let addItemView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? AddItemFooterView {
            
            footerView.addSubview(addItemView)
            addItemView.frame = CGRect(x: 0, y: 0, width: footerView.bounds.size.width, height: footerView.bounds.size.height)
            addItemView.addItemButton.setTitle(buttonTitle, for: .normal)
        }
        
        return footerView
    }
    
    @objc func toolbarDoneButtonPressed() {
        view.endEditing(true)
    }
    
}
