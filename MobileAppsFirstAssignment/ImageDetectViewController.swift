//
//  ImageDetectViewController.swift
//  MobileAppsFirstAssignment
//
//  Created by Joshua Yao on 1/25/19.
//  Copyright © 2019 Noah Sutter. All rights reserved.
//

import UIKit
import Alamofire

class ImageDetectViewController: UIViewController {
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGetCall(imageURL: "https://sightengine.com/assets/img/examples/example2.jpg")
    }
    
    
    func makeGetCall(imageURL: String) {
        
        
        // Set up the URL request
        //let endpoint = "https://api.sightengine.com/1.0/properties.json"
        let endpoint: String = "https://api.sightengine.com/1.0/properties.json?api_user=***REMOVED***&api_secret=***REMOVED***"//&url=\//(imageURL)"
        
        
        let imageData = selectedImage.image?.jpegData(compressionQuality: 1)
        
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
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
        
        
    }
}
