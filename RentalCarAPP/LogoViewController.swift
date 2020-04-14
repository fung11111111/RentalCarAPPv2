//
//  LogoViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 16/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
class LogoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(swichController), with: nil, afterDelay: 0.01)
    }
    
    
    @objc func swichController(){
        
        if Auth.auth().currentUser != nil{
            print("signed in")
            let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            
            self.view.window?.rootViewController = TabBarController
            self.view.window?.makeKeyAndVisible()
        }else{
            print("signed out")
            let customViewController = self.storyboard?.instantiateViewController(withIdentifier: "customViewController") as? customViewController
            
            self.view.window?.rootViewController = customViewController
            self.view.window?.makeKeyAndVisible()
        }
        
    }
}
