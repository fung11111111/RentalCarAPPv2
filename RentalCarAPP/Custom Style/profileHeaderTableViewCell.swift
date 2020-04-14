//
//  profileHeaderTableViewCell.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 28/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class profileHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bkView: customUIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
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
