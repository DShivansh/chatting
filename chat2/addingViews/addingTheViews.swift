//
//  addingTheViews.swift
//  chat2
//
//  Created by Shivansh Mishra on 28/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class addingTheViews: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    let heading:UITextField = {
        let field = UITextField()
        field.placeholder = "Enter the heading"
        field.translatesAutoresizingMaskIntoConstraints = false
        //        field.backgroundColor = .red
        return field
    }()
    
    let line:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionImage:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "nedstark")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    let details:UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = .red
        
        view.text = "Enter the description"
        view.textColor = UIColor.lightGray
        
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(heading)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(uploadingDataToDatabase))
        
        
        let height = self.navigationController?.navigationBar.frame.height
        heading.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        heading.topAnchor.constraint(equalTo: view.topAnchor, constant:height!+22).isActive = true
        heading.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heading.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(line)
        line.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: heading.bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(details)
        details.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        details.topAnchor.constraint(equalTo: line.bottomAnchor, constant:1).isActive = true
        details.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        details.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        details.delegate = self
        
        
        
        
        view.addSubview(descriptionImage)
        descriptionImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        descriptionImage.topAnchor.constraint(equalTo: details.bottomAnchor, constant:40).isActive = true
        descriptionImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        descriptionImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openingTheImagePicker)))
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if details.textColor == UIColor.lightGray{
            details.text = nil
            details.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if details.text.isEmpty{
            details.text = "Enter the description"
            details.textColor = UIColor.lightGray
        }
    }
    
    @objc func openingTheImagePicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("image was successfully selected")
        if let image = info["UIImagePickerControllerOriginalImage"]{
            descriptionImage.image = image as? UIImage
        }
        if let image = info["UIImagePickerControllerEditedImage"]{
            descriptionImage.image = image as? UIImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadingDataToDatabase(){
        print("i pressed done button")
        let alert = UIAlertController(title: "WARNING!!!!", message: "Heading is mandatory", preferredStyle: .alert)
        if (heading.text?.isEmpty)!{
            present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        else{
            
            
            let uniqueName = NSUUID().uuidString
            let ref = Storage.storage().reference().child("feedImages").child("\(uniqueName)")
            if let image = UIImageJPEGRepresentation(descriptionImage.image!, 0.1){
                ref.putData(image, metadata: nil, completion: { (metadata, error) in
                    if (error != nil){
                        print(error!)
                        return
                    }
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    self.uploadingImage(url: imageURL, heading: self.heading.text!, detailedView: self.details.text)
                })
            }
            
        }
    }
    
    
    
    func uploadingImage(url:String?,heading:String, detailedView:String?){
        let ref = Database.database().reference().child("newsFeed")
        var descript:String? = detailedView
        let uniqueRef = ref.childByAutoId()
        if detailedView! == "Enter the description"{
            descript = nil
        }
        let heighImage = descriptionImage.image?.size.height
        let values = ["imageURL":url, "heading":heading, "description": descript, "height": heighImage!] as [String : Any]
        uniqueRef.updateChildValues(values)
        details.text = "Enter the description"
        details.textColor = UIColor.lightGray
        descriptionImage.image = #imageLiteral(resourceName: "nedstark")
        self.heading.text = ""
    }
    
    
    
    
}
