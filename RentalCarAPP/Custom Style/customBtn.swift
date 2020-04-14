//
//  CustomerBtn.swift
//  SmartClock
//
//  Created by Fung Lam on 7/12/2019.
//  Copyright © 2019 Fung Lam. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {
  
    func setBtnStyle(){
        setRoundBtn()
        setGradient(colorOne: UIColor(red: 8.0/255.0, green: 74.0/255.0, blue: 196.0/255.0, alpha: 1.0),colorTwo: UIColor(red: 84.0/255.0, green: 144.0/255.0, blue: 248.0/255.0, alpha: 1.0))
    }
    
    private func setRoundBtn(){
        layer.cornerRadius =  self.frame.height/2
        layer.masksToBounds = true
        
        
    }
    func setGradient(colorOne: UIColor,colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x:1.0,y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
 
    func addBottomBorder(){
        let bottomLayer = CALayer()
        bottomLayer.borderWidth = 3
        bottomLayer.borderColor = UIColor.white.cgColor
        bottomLayer.frame = CGRect(x: 0, y: layer.frame.height, width: layer.frame.width, height: 3)
        
        layer.addSublayer(bottomLayer)
    }
    
    func removeBottomBorder(){
        let size = layer.sublayers?.count
        let removeRange: Range = 1..<size!
        
        layer.sublayers?.removeSubrange(removeRange)
        
    }
    
    func checkSize()->Int{
        let size = layer.sublayers?.count
        
        return size ?? 0
    }
    func setCircle(){
        
        layer.cornerRadius =  0.5 * bounds.size.width
        layer.masksToBounds = true
        
    }
    
}
