//
//  LandingPageViewController.swift
//  MobileAppsFirstAssignment
//
//  Created by Noah Sutter on 1/25/19.
//  Copyright © 2019 Noah Sutter. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    var selectedImage: UIImage!
    
    @IBAction func takePhotoPressed(_ sender: Any) {
        let vc = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            vc.sourceType = .camera
        }
        
        vc.allowsEditing = false
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        
        
        self.selectedImage = image
        
        // print out the image size as a test
        print(image.size)
        
        picker.dismiss(animated: true)
        
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "photoChosenSegue", sender: self)
        }
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing")
        if segue.identifier == "photoChosenSegue" {
            let dvc = segue.destination as! ImageDetectViewController
            dvc.passedImage = selectedImage
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
