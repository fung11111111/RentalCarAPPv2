//
//  SearchByImageViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 7/4/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit



class SearchByImageViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var searchPredictCars: UILabel!
    
    @IBOutlet weak var labelGradient: customUIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputCollectionView: UICollectionView!
    
    @IBOutlet weak var selectImgView: customUIView!
    @IBOutlet weak var selectPhoLbl: UILabel!
    let pickerController = UIImagePickerController()
    let model = carpredictModel()
    var result: [Predictions] = []
    var topFive: [Predictions] = []
    var singleItemDelegate: searchItemDelegate?
    let color1 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    let color2 = UIColor(red: 255.0/255.0, green: 95.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleConfig()
        pickerController.delegate = self
        configTapGesture()
        tappedImgView()
       
    }
    func styleConfig(){

       // gradient labek
        labelGradient.setGradientBackground(colorOne: color1, colorTwo: color2)
        labelGradient.mask = searchPredictCars
        
        
        // image view
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        
        
       
        
        // select photo label
        selectPhoLbl.layer.borderWidth = 1.0
        selectPhoLbl.layer.cornerRadius = 10.0
        selectPhoLbl.layer.masksToBounds = true
        selectPhoLbl.layer.borderColor = UIColor.clear.cgColor
    }
  
    @objc func handleImageTap(){
        print("image Tapped")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        
        self.present(image,animated: true)
        
    }
    func tappedImgView(){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showActionSheet)))
        
        imageView.isUserInteractionEnabled = true
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(SearchByImageViewController.handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topFive.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "predictionCell", for: indexPath) as! PredictionCollectionViewCell
        
        cell.carNameLbl.text = topFive[indexPath.row].carName
        cell.accuracyLbl.text = String(topFive[indexPath.row].accuracy) + "%"

        
        cell.progressView.layer.cornerRadius = 10
        cell.progressView.clipsToBounds = true
        cell.progressView.layer.sublayers![1].cornerRadius = 10
        cell.progressView.subviews[1].clipsToBounds = true
       
      
        let gradientImg = gradientImage(with: cell.progressView.frame,
                                                colors: [color1.cgColor, color2.cgColor],
                                                locations: nil)
        
        cell.progressView.progressImage = gradientImg!
        cell.progressView.setProgress(Float(topFive[indexPath.row].accuracy/100.0), animated: true)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped")
        singleItemDelegate?.getItem(itemName: topFive[indexPath.row].carName)
        dismiss(animated: true, completion: nil)
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
    
    @objc func showActionSheet() {
        let sheet = UIAlertController(title: "Car model detection", message: "Pick a car image!", preferredStyle: .actionSheet)
        let takePic = UIAlertAction(title: "Take Picture", style: .default) { (action) in
            print("take picture tapped")
            self.pickerController.sourceType = .camera
            self.present(self.pickerController,animated: true, completion: nil)
        }
        let uploadPic = UIAlertAction(title: "Upload Picture", style: .default) { (action) in
            print("upload picture tapped")
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController,animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        sheet.addAction(takePic)
        sheet.addAction(uploadPic)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
    }
    
}
extension SearchByImageViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("set image")
        
        if let img = info[.originalImage] as? UIImage{
            imageView.image = img
            let pixelBuffer = img.pixelBuffer()
            if let pixelBuffer = pixelBuffer{
                let output = try? model.prediction(image: pixelBuffer)
                
                
                for prediction in output!.output{
                    let res = Predictions(carName: prediction.key.trimmingCharacters(in: .newlines), accuracy: Double(round(100*prediction.value*100.0)/100))
                    result.append(res)
                }
                
                let sortedRes = result.sorted(by: {
                    $0.accuracy > $1.accuracy
                })
                for i in 0...4{
                    topFive.append(sortedRes[i])
                }
                outputCollectionView.reloadData()
            }else{
                print("no image buffer")
            }
        }else{
            print("cannot set image")
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("close camera")
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let width = 224
        let height = 224
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            print("not resultPixelBuffer")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        print("no content")
                                        return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
}


