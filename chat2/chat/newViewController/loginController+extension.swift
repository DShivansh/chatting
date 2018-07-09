//
//  loginController+extension.swift
//  chat2
//
//  Created by Shivansh Mishra on 11/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
extension loginScreen:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func ShowingImagesToBePut(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
        
            SignImage.image = editedImage
            
        }
        else if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            SignImage.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel button was pressed")
        dismiss(animated: true, completion: nil)
    }
    
}
