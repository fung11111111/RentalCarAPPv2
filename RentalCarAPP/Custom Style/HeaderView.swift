//
//  HeaderView.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 18/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {

    @IBOutlet weak var headerTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addShadow(){
         layer.shadowColor = UIColor.lightGray.cgColor
         layer.shadowOffset = CGSize(width:0,height: 3.0)
         layer.shadowRadius = 2.0
         layer.shadowOpacity = 1.0
         layer.masksToBounds = false
         layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
         
     }
}
