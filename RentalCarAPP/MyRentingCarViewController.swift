//
//  MyRentingCarViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 12/4/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

class MyRentingCarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var myOrder:[Order] = []
    var ownerInfo: [PersonalInfo]?
    var carData: [ItemInfo]?
    var rentingCars: [MyrentingCar] = []
    @IBOutlet weak var orderCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOrderObj()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rentingCars.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myrentingcar", for: indexPath) as! MyRentingCarCollectionViewCell
        
        cell.carImg?.sd_setImage(with: URL(string: rentingCars[indexPath.row].itemInfo!.car.image_url), placeholderImage: nil, options: .handleCookies, completed: nil)
        cell.duration.text = "From \(rentingCars[indexPath.row].order!.duration)"
        cell.totalPrice.text = "Total Price: \(String(rentingCars[indexPath.row].order!.totalPrice))"
        cell.orderId.text = "Order ID: \(rentingCars[indexPath.row].order!.orderId)"
        cell.carBrand.text = rentingCars[indexPath.row].itemInfo!.car.brand
        cell.carModel.text = rentingCars[indexPath.row].itemInfo!.car.model
        cell.ownerName.text = "Name: \(rentingCars[indexPath.row].ownerInfo!.firstName)"
        cell.ownerPhone.text = "Contact Number: \(rentingCars[indexPath.row].ownerInfo!.countryCode) \(rentingCars[indexPath.row].ownerInfo!.phoneNumber)"
        
        cell.styleConfig()
        return cell
    }
    func fetchOrderObj(){
        FireDataLoader().fectchMyOrder { (orders) in
            print(self.myOrder.count)
            for order in orders{
                FireDataLoader().fectchSpecificCar(itemId: order.carId) { (carInfo) in
                    FireDataLoader().fetchUserInfo(userId: carInfo.ownerId) { (ownerInfo) in
                        let myrentingCars = MyrentingCar(itemInfo: carInfo, order: order, ownerInfo: ownerInfo)
                        self.rentingCars.append(myrentingCars)
                        self.orderCollectionView.reloadData()
                    }
                }
            }
        }
    }

}
