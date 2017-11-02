//
//  ViewController.swift
//  Spoliers
//
//  Created by Nainesh Jethwa on 10/31/17.
//  Copyright © 2017 Nainesh Jethwa. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
      let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                
                fatalError("Failed to convert image")
            }
            
            detect(image: ciimage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func detect(image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model:model) { (request, error) in
         
            guard  let result = request.results as? [VNClassificationObservation] else {
            
            fatalError("Failed to request")
            }
            if let firstResult = result.first{
                if firstResult.identifier.contains("Pizza"){
                    self.navigationItem.title = "Pizza!"
                    
                }else {
                    self.navigationItem.title = "Not Pizza!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try! handler.perform([request])
        }
        catch {
            print(error)
            
        }
    }
    
    @IBAction func camera(_ sender: Any) {
        
        
         present(imagePicker, animated: true, completion: nil)
        
        
    }
    

}

