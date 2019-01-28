//
//  ImageDetectViewController.swift
//  MobileAppsFirstAssignment
//
//  Created by Joshua Yao on 1/25/19.
//  Copyright © 2019 Noah Sutter. All rights reserved.
//

import UIKit
import Alamofire

class ImageDetectViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var primaryColor: UIImageView!
    @IBOutlet weak var secondaryColor: UIImageView!
    @IBOutlet weak var tirtiaryColor: UIImageView!
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var tirtiaryLabel: UILabel!
    
    var passedImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedImage.image = passedImage
        makeGetCall()
    }
   
    
    func makeGetCall() {
        
        // Set up the URL request
        //let endpoint = "https://api.sightengine.com/1.0/properties.json"
        let endpoint: String = "https://api.sightengine.com/1.0/properties.json?api_user=***REMOVED***&api_secret=***REMOVED***"//&url=\//(imageURL)"

        var quality = 0.75
        var imageData = selectedImage.image?.jpegData(compressionQuality: CGFloat(quality))
        while ((imageData?.count)! / 1048576 > 10) {
            quality = quality - 0.05
            print(quality)
            imageData = selectedImage.image?.jpegData(compressionQuality: CGFloat(quality))
        }
        
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "media", fileName: "file.jpg", mimeType: "image/jpeg")
        },
            to: endpoint,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        guard response.result.isSuccess else {
                            print("Error while fetching colors")
                            return
                        }
                        
                        guard let value = response.result.value as? [String: Any],
                            let colors = value["colors"] as? [String: Any?],
                            let dominant = colors["dominant"] as? [String: Any],
                            let dominantHex = dominant["hex"] as? String,
                            let others = colors["other"] as? [[String: Any]]
                        else {
                                print("Missing data")
                                return
                        }
                        
                        var secondaryHex = "FFFFFF"
                        var tirtiaryHex = "FFFFFF"
                        if others.count >= 2 {
                            secondaryHex = others[0]["hex"] as! String
                            tirtiaryHex = others[1]["hex"] as! String
                        } else if others.count >= 1 {
                            secondaryHex = others[0]["hex"] as! String
                        }
                        
                        self.primaryColor.image = UIImage.imageWithColor(tintColor: UIColor(hexString: dominantHex)!)
                        self.secondaryColor.image = UIImage.imageWithColor(tintColor: UIColor(hexString: secondaryHex)!)
                        self.tirtiaryColor.image = UIImage.imageWithColor(tintColor: UIColor(hexString: tirtiaryHex)!)
                        
                        self.primaryLabel.text = dominantHex
                        self.secondaryLabel.text = secondaryHex
                        self.tirtiaryLabel.text = tirtiaryHex
                        
                        print(colors)
                        print(dominant)
                        print(dominantHex)
                        print(others)
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
}
extension UIImage {
    static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
