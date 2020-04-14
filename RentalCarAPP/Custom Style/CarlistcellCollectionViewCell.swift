//
//  CarlistcellCollectionViewCell.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 31/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class CarlistcellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var transmission: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var hkd: UILabel!
   
    @IBOutlet weak var gradientLbl0: customUIView!
    @IBOutlet weak var gradientLbl1: customUIView!
    let color1 = UIColor(red: 255.0/255.0, green: 95.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    let color2 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    
    func styleConfig(){
        addCornerRadius()
        addShadow()
        ratingLabel.layer.cornerRadius = 5
        ratingLabel.layer.masksToBounds = true
        
        // gradientLabel
        gradientLbl0.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientLbl1.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientLbl1.mask = price
        gradientLbl0.mask = hkd
    }
    
    func addShadow(){
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 5.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    func addCornerRadius(){
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        
    }
    
}
