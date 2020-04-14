//
//  MyRentingCarCollectionViewCell.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 12/4/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class MyRentingCarCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var carImg: UIImageView!
    
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerPhone: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var gradientLabel: customUIView!
    
   
    let color1 = UIColor(red: 255.0/255.0, green: 95.0/255.0, blue: 121.0/255.0, alpha: 1.0)
     let color2 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    func styleConfig(){
        addCornerRadius()
        addShadow()
        imageViewStyle()
        
        gradientLabel.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientLabel.mask = orderId
        
        
    }
    func addShadow(){
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 5.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    func addCornerRadius(){
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
    }
    func imageViewStyle(){
        carImg.layer.borderWidth = 1.0
        carImg.layer.cornerRadius = 10.0
        carImg.layer.masksToBounds = true
        carImg.layer.borderColor = UIColor.lightGray.cgColor
    }
}
