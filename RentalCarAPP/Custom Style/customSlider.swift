//
//  customSlider.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 19/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

@IBDesignable
class customSlider: UISlider {


    @IBInspectable var thumbImage: UIImage?{
        didSet{
            setThumbImage(thumbImage, for: .normal)
        }
    }


}
