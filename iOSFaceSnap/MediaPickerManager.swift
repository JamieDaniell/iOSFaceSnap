//
//  MediaPickerManager.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 11/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import MobileCoreServices

// define the MediaPickerManagerDelegate 
protocol MediaPickerManagerDelegate: class
{
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

// define the mediapickermanager-> Decides which photo to pick
class MediaPickerManager: NSObject
{
    // deifine two controllers
    private let imagePickerController = UIImagePickerController()
    private let presentingViewController: UIViewController
    
    weak var delegate: MediaPickerManagerDelegate?
    
    // deifine the initaliser
    init(presentingViewController: UIViewController)
    {
        self.presentingViewController = presentingViewController
        super.init()
        imagePickerController.delegate = self
        
        // set the front camera as the image source
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        }
        else// if the fornt camera is not available then use the library
        {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    // present the image picker
    func presentImagePickerController(animated: Bool)
    {
        presentingViewController.present(imagePickerController, animated: animated, completion: nil)
    }
    // dismiss the image picker 
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void))
    {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }

}



extension MediaPickerManager: UINavigationControllerDelegate , UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
        
        
    }
}









