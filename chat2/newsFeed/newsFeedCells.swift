//
//  newsFeedCells.swift
//  chat2
//
//  Created by Shivansh Mishra on 26/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
class newsFeedCells: UICollectionViewCell {
    
    let view:UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let heading:UILabel = {
        let view = UILabel()
        view.text = "Test Heading"
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        return view
    }()
    
    let details:UITextView = {
        let view = UITextView()
        view.text = "testing bro"
        view.font = UIFont.systemFont(ofSize: 14)
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let image:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "coupleImage")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(view)
//        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        addSubview(heading)
        heading.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        heading.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heading.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        heading.heightAnchor.constraint(equalToConstant:40).isActive = true
//
//
//
//
//        addSubview(details)
//        details.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        details.topAnchor.constraint(equalTo: heading.bottomAnchor).isActive = true
//        details.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        details.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
        let height = image.image?.size.height
        addSubview(image)
        image.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        image.widthAnchor.constraint(equalTo:self.widthAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: height!/10).isActive = true
        
        
        addSubview(details)
        details.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        details.topAnchor.constraint(equalTo: heading.bottomAnchor).isActive = true
        details.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        details.bottomAnchor.constraint(equalTo: image.topAnchor).isActive = true
        

        
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
