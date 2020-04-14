//
//  MyListingCarCollectionViewCell.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 10/3/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit


class MyListingCarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var transmission: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var id: UILabel!
    
    let color1 = UIColor(red: 255.0/255.0, green: 95.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    let color2 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    @IBOutlet weak var gradientLabel: customUIView!
    
    func styleConfig(){
        addCornerRadius()
        addShadow()
        gradientLabel.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientLabel.mask = id
        
    }
    
    func addShadow(){
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    func addCornerRadius(){
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        
    }
}
