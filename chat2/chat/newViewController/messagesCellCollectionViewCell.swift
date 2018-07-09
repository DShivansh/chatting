//
//  messagesCellCollectionViewCell.swift
//  chat2
//
//  Created by Shivansh Mishra on 15/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit

class messagesCellCollectionViewCell: UICollectionViewCell {
    
    var initialLoad = true
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.text = "Text testing"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isScrollEnabled = false
        tv.isEditable = false
//        tv.backgroundColor = .red
        return tv
    }()
    
    let blueBubble:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 250/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
//        view.clipsToBounds
        return view
    }()
    
  let imageView:UIImageView = {
        let profilePicture = UIImageView()
        //profilePicture.image = #imageLiteral(resourceName: "nedstark")
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.layer.cornerRadius = 16
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill

        return profilePicture
        
    }()
    
   
    var controllerReference:chatLogController?
    
    lazy var sendImage:UIImageView = {
        let profilePicture = UIImageView()
        //profilePicture.image = #imageLiteral(resourceName: "nedstark")
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.layer.cornerRadius = 16
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlingTheTapOfImage)))
        return profilePicture
    }()
    
    @objc func handlingTheTapOfImage(tapGesture:UITapGestureRecognizer){
        if let reference = controllerReference{
            if let image = tapGesture.view as? UIImageView{
                reference.handlingZoom(image)
            }
        }
    }
    
    
    
    
    var blueBubbleWidthAnchor = NSLayoutConstraint()
    var blueBubbleRightAnchor = NSLayoutConstraint()
    var blueBubbleLeftAnchor = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(blueBubble)
        blueBubbleRightAnchor = blueBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-4)
        blueBubbleRightAnchor.isActive = true
        blueBubbleLeftAnchor = blueBubble.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8)
        blueBubble.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blueBubbleWidthAnchor = blueBubble.widthAnchor.constraint(equalToConstant: 250)
        blueBubbleWidthAnchor.isActive = true
        blueBubble.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textView)
       //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: blueBubble.leftAnchor, constant: 4).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textView.rightAnchor.constraint(equalTo: blueBubble.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        if initialLoad {
            blueBubble.addSubview(sendImage)
            sendImage.leftAnchor.constraint(equalTo: blueBubble.leftAnchor).isActive = true
            sendImage.topAnchor.constraint(equalTo: blueBubble.topAnchor).isActive = true
            sendImage.widthAnchor.constraint(equalTo: blueBubble.widthAnchor).isActive = true
            sendImage.heightAnchor.constraint(equalTo: blueBubble.heightAnchor).isActive = true
        }
        
        initialLoad = false
        
        
        
    }
    
    override func prepareForReuse() {
        initialLoad = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
