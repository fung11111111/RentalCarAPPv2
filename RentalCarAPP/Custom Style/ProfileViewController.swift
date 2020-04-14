//
//  ProfileViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 7/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseUI
class ProfileViewController: UIViewController {

    @IBOutlet weak var btnView: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
    }
   
   
    @IBAction func signoutBtn(_ sender: Any) {
        do {
                  try Auth.auth().signOut()
                  print ("signout")
                  let customViewController = self.storyboard?.instantiateViewController(withIdentifier: "customViewController") as? customViewController
                  
                  self.view.window?.rootViewController = customViewController
                  self.view.window?.makeKeyAndVisible()
              } catch let err {
                  print(err)
              }
    }
    
}
