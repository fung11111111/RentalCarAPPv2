//
//  dataLoader.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 5/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import Foundation

public class DataLoader{
    
    @Published var userData = [ItemInfo]()
    
    init() {
        fetchData()
    }
    func fetchData(){
        if let filepath = Bundle.main.url(forResource: "userdata", withExtension: "json"){
            
            do{
                let data = try Data(contentsOf: filepath)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                //print(json)
                
                guard let dataArray = json as? [Any] else {return}
                
                for eachDict in dataArray{
                    guard let dataDictionary = eachDict as?  [String: Any] else {return}
              //      guard let personalInfor = dataDictionary["personalInfor"] as? [String: Any] else {return}
                    guard let address = dataDictionary["address"] as? [String: Any] else {return}
                    guard let cars = dataDictionary["cars"] as? [String: Any] else {return}
                    
                    
                    guard let id = dataDictionary["id"] as? String else {print("not string"); return}
                    guard let ownerId = dataDictionary["ownerId"] as? String else {print("not string"); return}
                    
                    guard let orderId = dataDictionary["orderId"] as? String else {print("not string"); return}
                    // create address object
                    guard let streetname = address["streetname"] as? String else {print("not string"); return}
                    guard let lat = address["lat"] as? Double else {print("not double"); return}
                    guard let lng = address["lng"] as? Double else {print("not double"); return}
                    
                    // create car objec
                    guard let year = cars["year"] as? String else {print("not String"); return}
                    guard let brand = cars["brand"] as? String else {print("not String"); return}
                    guard let model = cars["model"] as? String else {print("not String"); return}
                    guard let size = cars["size"] as? String else {print("not String"); return}
                    guard let paint_color = cars["paint_color"] as? String else {print("not String"); return}
                    guard let image_url = cars["image_url"] as? String else {print("not String"); return}
                    guard let transmission = cars["transmission"] as? String else {print("not String"); return}
                    guard let type = cars["type"] as? String else {print("not String"); return}
                    guard let condition = cars["condition"] as? Bool else {print("not Bool"); return}
                    guard let price = cars["price"] as? Int else {print("not String"); return}
                    
                    let addressObj = Address(streetname: streetname, lat: lat, lng: lng)
                    let carObj = Cars(year: year, brand: brand, model: model, size: size, paint_color: paint_color, image_url: image_url, transmission: transmission, type: type, condition: condition, price: price)
                    let userObj = ItemInfo(id: id, ownerId: ownerId, orderId: orderId, car: carObj, address: addressObj)
                    
                    userData.append(userObj)
                   // print(userObj.id)
                // print(userObj.address.streetname)
                }
            }catch{
                print(error)
                
            }
            
        }
        
    }
    
}
