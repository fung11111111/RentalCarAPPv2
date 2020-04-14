//
//  testViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 1/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import PassKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CoreML
class testViewController: UIViewController{
    
    
    
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    //  let image = UIImage(named: "dog1")
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewConfig()
        
        
    }
    func gradientImage(with bounds: CGRect,
                       colors: [CGColor],
                       locations: [NSNumber]?) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    func progressViewConfig(){
        
      
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        
        let color1 = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        let color2 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        
        let gradientImg = gradientImage(with: progressView.frame,
                                          colors: [color1.cgColor, color2.cgColor],
                                          locations: nil)
        
        progressView.progressImage = gradientImg!
        progressView.setProgress(0.75, animated: true)
    }
    
    
}







