//
//  customViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 15/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class customViewController: UINavigationController {
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
