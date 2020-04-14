//
//  FireDataLoader.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 6/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

public class FireDataLoader{
    
    init(){
        
    }
    func fectchData(completion:  @escaping ([ItemInfo]) -> ()){
        let dbReference = Database.database().reference()
        
        dbReference.child("carjson").queryOrderedByKey().observe(.value) { (snapshot) in
            
            if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                var tempData = [ItemInfo]()
                for eachSnap in snap{
                    // get the main dictionary
                    guard let mainDic = eachSnap.value as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    
                    guard let id = mainDic["id"] as? String else {
                        print("not string");return
                    }
                    guard let ownerId = mainDic["ownerId"] as? String else {
                        print("not string");return
                    }
                    
                    guard let orderId = mainDic["orderId"] as? String else {
                        print("not string");return
                    }
                    // get the address dictionary
                    guard let addressDic = mainDic["address"] as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    // get data from addtess dictionary
                    guard let streetname = addressDic["streetname"] as? String else {print("not string"); return}
                    guard let lat = addressDic["lat"] as? Double else {print("not double"); return}
                    guard let lng = addressDic["lng"] as? Double else {print("not double"); return}
                    
                    // get the car dictionary
                    guard let carDic = mainDic["cars"] as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    // get data from car dictionary
                    guard let year = carDic["year"] as? String else {print("not String"); return}
                    guard let brand = carDic["brand"] as? String else {print("not String"); return}
                    guard let model = carDic["model"] as? String else {print("not String"); return}
                    guard let size = carDic["size"] as? String else {print("not String"); return}
                    guard let paint_color = carDic["paint_color"] as? String else {print("not String"); return}
                    guard let image_url = carDic["image_url"] as? String else {print("not String"); return}
                    guard let transmission = carDic["transmission"] as? String else {print("not String"); return}
                    guard let type = carDic["type"] as? String else {print("not String"); return}
                    guard let condition = carDic["condition"] as? Bool else {print("not Bool"); return}
                    guard let price = carDic["price"] as? Int else {print("not String"); return}
                    
                    //create the object
                    let addressObj = Address(streetname: streetname, lat: lat, lng: lng)
                    let carObj = Cars(year: year, brand: brand, model: model, size: size, paint_color: paint_color, image_url: image_url, transmission: transmission, type: type, condition: condition, price: price)
                    let userObj = ItemInfo(id: id, ownerId: ownerId, orderId: orderId, car: carObj, address: addressObj)
                    
                    tempData.append(userObj)
                }
                completion(tempData)
            }
        }
    }
    
    func fetchUserInfo(userId: String, completion:  @escaping (PersonalInfo) -> ()){
        let uid = userId
        let dbReference = Database.database().reference()
        
        dbReference.child("userinfo").child(uid).queryOrderedByKey().observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else{print("not string obj"); return}
            guard let email = dic["email"] as? String else {print("not String"); return}
            guard let firsName = dic["firstName"] as? String else {print("not String"); return}
            guard let lastName = dic["lastName"] as? String else {print("not String"); return}
            guard let phoneNumber = dic["phoneNumber"] as? String else {print("not String"); return}
            guard let gender = dic["gender"] as? String else {print("not String"); return}
            guard let dateOfBirth = dic["dateOfBirth"] as? String else {print("not String"); return}
            guard let countryCode = dic["countryCode"] as? String else {print("not String"); return}
            guard let renting = dic["renting"] as? Int else {print("not int"); return}
            guard let listing = dic["listing"] as? Int else {print("not int"); return}
            let personInfo = PersonalInfo(firstName: firsName, lastName: lastName, email: email,phoneNumber: phoneNumber,gender: gender, dateOfBirth: dateOfBirth, countryCode: countryCode, renting: renting, listing: listing)
            
            
            completion(personInfo)
            
        }
    }
    func fetchListingCar(userId: String, completion:  @escaping ([ItemInfo]) -> ()){
        let dbReference = Database.database().reference()
        dbReference.child("carjson").queryOrderedByKey().observe(.value) { (snapshot) in
            var tempListingCars: [ItemInfo] = []
            if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                for eachSnap in snap{
                    // get the main dictionary
                    guard let mainDic = eachSnap.value as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    
                    guard let id = mainDic["id"] as? String else {
                        print("not string");return
                    }
                    guard let ownerId = mainDic["ownerId"] as? String else {
                        print("not string");return
                    }
                    
                    guard let orderId = mainDic["orderId"] as? String else {
                        print("not string");return
                    }
                    // get the address dictionary
                    guard let addressDic = mainDic["address"] as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    // get data from addtess dictionary
                    guard let streetname = addressDic["streetname"] as? String else {print("not string"); return}
                    guard let lat = addressDic["lat"] as? Double else {print("not double"); return}
                    guard let lng = addressDic["lng"] as? Double else {print("not double"); return}
                    
                    // get the car dictionary
                    guard let carDic = mainDic["cars"] as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    
                    // get data from car dictionary
                    guard let year = carDic["year"] as? String else {print("not String"); return}
                    guard let brand = carDic["brand"] as? String else {print("not String"); return}
                    guard let model = carDic["model"] as? String else {print("not String"); return}
                    guard let size = carDic["size"] as? String else {print("not String"); return}
                    guard let paint_color = carDic["paint_color"] as? String else {print("not String"); return}
                    guard let image_url = carDic["image_url"] as? String else {print("not String"); return}
                    guard let transmission = carDic["transmission"] as? String else {print("not String"); return}
                    guard let type = carDic["type"] as? String else {print("not String"); return}
                    guard let condition = carDic["condition"] as? Bool else {print("not Bool"); return}
                    guard let price = carDic["price"] as? Int else {print("not String"); return}
                    
                    //create the object
                    if ownerId == userId{
                        let addressObj = Address(streetname: streetname, lat: lat, lng: lng)
                        let carObj = Cars(year: year, brand: brand, model: model, size: size, paint_color: paint_color, image_url: image_url, transmission: transmission, type: type, condition: condition, price: price)
                        let listingCar = ItemInfo(id: id, ownerId: ownerId, orderId: orderId, car: carObj, address: addressObj)
                        tempListingCars.append(listingCar)
                    }
                    
                }
                completion(tempListingCars)
            }
        }
        
    }
    
    func fectchSpecificCar(itemId: String, completion:  @escaping (ItemInfo) -> ()){
        let dbReference = Database.database().reference()
        
        dbReference.child("carjson").child(itemId).queryOrderedByKey().observe(.value) { (snapshot) in
            // get the main dictionary
            guard let mainDic = snapshot.value as? [String: AnyObject] else {
                print("not String obj");return
            }
            
            guard let id = mainDic["id"] as? String else {
                print("not string");return
            }
            guard let ownerId = mainDic["ownerId"] as? String else {
                print("not string");return
            }
            
            guard let orderId = mainDic["orderId"] as? String else {
                print("not string");return
            }
            // get the address dictionary
            guard let addressDic = mainDic["address"] as? [String: AnyObject] else {
                print("not String obj");return
            }
            
            // get data from addtess dictionary
            guard let streetname = addressDic["streetname"] as? String else {print("not string"); return}
            guard let lat = addressDic["lat"] as? Double else {print("not double"); return}
            guard let lng = addressDic["lng"] as? Double else {print("not double"); return}
            
            // get the car dictionary
            guard let carDic = mainDic["cars"] as? [String: AnyObject] else {
                print("not String obj");return
            }
            
            // get data from car dictionary
            guard let year = carDic["year"] as? String else {print("not String"); return}
            guard let brand = carDic["brand"] as? String else {print("not String"); return}
            guard let model = carDic["model"] as? String else {print("not String"); return}
            guard let size = carDic["size"] as? String else {print("not String"); return}
            guard let paint_color = carDic["paint_color"] as? String else {print("not String"); return}
            guard let image_url = carDic["image_url"] as? String else {print("not String"); return}
            guard let transmission = carDic["transmission"] as? String else {print("not String"); return}
            guard let type = carDic["type"] as? String else {print("not String"); return}
            guard let condition = carDic["condition"] as? Bool else {print("not Bool"); return}
            guard let price = carDic["price"] as? Int else {print("not String"); return}
            
            //create the object
            let addressObj = Address(streetname: streetname, lat: lat, lng: lng)
            let carObj = Cars(year: year, brand: brand, model: model, size: size, paint_color: paint_color, image_url: image_url, transmission: transmission, type: type, condition: condition, price: price)
            let itemObj = ItemInfo(id: id, ownerId: ownerId, orderId: orderId, car: carObj, address: addressObj)
            
            completion(itemObj)
        }
        
    }
    
    func fectchMyOrder(completion:  @escaping ([Order]) -> ()){
        let dbReference = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        dbReference.child("order").queryOrderedByKey().observe(.value) { (snapshot) in
            if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                var tempOrder: [Order] = []
                for eachSnap in snap{
                    
                    guard let mainDic = eachSnap.value as? [String: AnyObject] else {
                        print("not String obj");return
                    }
                    guard let orderId = mainDic["orderId"] as? String else {
                        print("not string");return
                    }
                    guard let carId = mainDic["carId"] as? String else {
                        print("not string");return
                    }
                    guard let renterId = mainDic["renterId"] as? String else {
                        print("not string");return
                    }
                    guard let duration = mainDic["duration"] as? String else {
                        print("not string");return
                    }
                    guard let totalPrice = mainDic["totalPrice"] as? Int else {print("not Int"); return}
                    
                    if renterId == uid!{
                        let order = Order(orderId: orderId, carId: carId, renterId: renterId, duration: duration, totalPrice: totalPrice)
                        tempOrder.append(order)
                    }
                }
                completion(tempOrder)
                
            }
        }
    }
}
