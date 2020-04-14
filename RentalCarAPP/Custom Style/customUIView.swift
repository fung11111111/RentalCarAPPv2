//
//  customUIView.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 13/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class customUIView: UIView {
    
    
    
    func setGradientBackground(colorOne: UIColor,colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x:1.0,y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    func setRounded(){
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
    func setCircle(){
        
    }
    
    func addShadow(){
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 5.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
    }
    
    func popupbtnShadow(bounds:  CGRect,cornerRadius: CGFloat){
        layer.shadowColor = UIColor(displayP3Red: 144.0/255.0, green: 189.0/255.0, blue: 242.0/255.0, alpha: 0.7).cgColor
        layer.shadowOffset = CGSize(width: -2.0,height: 3.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

}
