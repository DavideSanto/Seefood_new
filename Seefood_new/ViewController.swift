//
//  ViewController.swift
//  Seefood_new
//
//  Created by Davide Santo on 09.07.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import RestKit
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    let apiKey = "KQINzbR3vkddyL4C43_anPQlWLLxX32-G_PpHFyBvGAh"
    let version = "2019-07-09"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isHidden = true
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraButton.isEnabled = false
        photoLibraryButton.isEnabled = false
        shareButton.isHidden = true
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            guard let imageData = UIImage(data: image.jpegData(compressionQuality: 0.1)!) else {fatalError("Could Not create JPEG")}
            
            let visualRecongition = VisualRecognition(version: version, apiKey: apiKey)
            
            
            visualRecongition.classify(image: imageData ) { (restRespond, watsonerror) in
            
                
                if let classifiedImage = restRespond?.result?.images {
                    let classifiers = classifiedImage.first!.classifiers
                    let classification = classifiers.first?.classes.first?.className
                    DispatchQueue.main.async {
                        
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                        
                        self.navigationItem.title = classification! + "😃 "
                        //self.navigationItem.largeTitleDisplayMode = .automatic
                        self.cameraButton.isEnabled = true
                        self.photoLibraryButton.isEnabled = true
                        SVProgressHUD.dismiss()
                        self.shareButton.isHidden = true
                        
                    }
                    
                }
                
            }
            
        } else {
        print("There was an error picking the image")
        }
    }

    @IBAction func cameraTapper(_ sender: Any) {
        
        imagePicker.sourceType = .camera // .savedPhotosAlbum  
        imagePicker.allowsEditing = false
        present(imagePicker,animated: true,completion: nil)
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker,animated: true,completion: nil)
        
    }
    
    @IBAction func sharedButtonPressed(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("See if you agree 😂")
            present(vc!, animated: true, completion: nil)
        
        } else {
            navigationItem.title = "Login to Twitter"
        }
    }
    
}

