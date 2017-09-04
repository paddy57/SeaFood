//
//  ViewController.swift
//  SeaFood
//
//  Created by pradnyanand milind pohare on 01/09/17.
//  Copyright © 2017 pradnyanand milind pohare. All rights reserved.
//

import UIKit
import CoreML
//vision is to make image recognisation process smooth and allow images to work with corml
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    //creating imagepicker object
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    //tells to delegate tht user has picked the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //to make sure imae picked is not nill
        //we set a constant image to picked image by imgepicker
        //UIImagePickerControllerOriginalImage is key which gives us the image from info dictionary
        //we are also doing optional binding to make the value of image type as info is of any datatype
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            imageView.image = userPickedImage
            //CIImage i.e core image which helps to get interpreter from vision and coreml framework
            guard let ciimage = CIImage(image: userPickedImage) else{
                
                
                fatalError("Could not convert to ci image")
            }
            
            detect(image: ciimage)
            
            
        }
        //to dismiss imagepicker after picking image
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    //function to detect core image from model
    func detect(image: CIImage){
        
        //to use inception model
        //Inceptionv3().model its model property of inception
        //we right guard if loading of coreimage faild
        //VNCoreMLModel is aprt of vision which uses coreml mode tp process image
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            
            
            fatalError("loadingcoreml model faild")
        }
        
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model faild to process image")
            }
            
            
            if let firstResult = results.first{
                
                if firstResult.identifier.contains("hotdog"){
                    
                    self.navigationItem.title = "Hotdog"
                }
                else{
                    self.navigationItem.title = firstResult.identifier
                }
                
            }
        }
        
        //handler which specifies which image to classify
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
        try handler.perform([request])
        }
        catch{
    
           print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //to trigger imagepicker to happend
        present(imagePicker, animated: true, completion: nil)
    }
    
}

