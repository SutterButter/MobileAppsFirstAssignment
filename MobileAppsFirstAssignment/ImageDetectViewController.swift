//
//  ImageDetectViewController.swift
//  MobileAppsFirstAssignment
//
//  Created by Joshua Yao on 1/25/19.
//  Copyright © 2019 Noah Sutter. All rights reserved.
//

import UIKit

class ImageDetectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGetCall(imageURL: "https://sightengine.com/assets/img/examples/example2.jpg")
    }
    
    
    func makeGetCall(imageURL: String) {
        // Set up the URL request
        let endpoint: String = "https://api.sightengine.com/1.0/properties.json?api_user=***REMOVED***&api_secret=***REMOVED***&url=\(imageURL)"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            do {
                guard let imageData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // test
                print("The dominant color is: " + imageData.colors.dominant)
            }
        }
        task.resume()
    }
}
