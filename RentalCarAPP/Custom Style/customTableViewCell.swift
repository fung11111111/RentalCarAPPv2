//
//  customTableViewCell.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 16/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         addCornerRadius()
       // addShadow()
    }
    
    
    func addCornerRadius(){
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        contentView.layoutMargins.left = 10
        contentView.layoutMargins.right = 10
    }
    func addShadow(){
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 5.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    
}
