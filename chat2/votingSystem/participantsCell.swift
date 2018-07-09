//
//  participantsCell.swift
//  chat2
//
//  Created by Shivansh Mishra on 19/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
class participantsCell:UITableViewCell{
    
    let LeftProfileImage:UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = #imageLiteral(resourceName: "gameofthrones_splash")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        //profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(LeftProfileImage)
        LeftProfileImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        LeftProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        LeftProfileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        LeftProfileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        textLabel?.translatesAutoresizingMaskIntoConstraints = false
//        textLabel?.leftAnchor.constraint(equalTo: LeftProfileImage.rightAnchor, constant:10).isActive = true
////        textLabel?.bottomAnchor.constraint(equalTo: LeftProfileImage.bottomAnchor).isActive = true
//        textLabel?.centerYAnchor.constraint(equalTo: LeftProfileImage.centerYAnchor).isActive = true
//        textLabel?.widthAnchor.constraint(equalToConstant: textLabel!.frame.width).isActive = true
//        textLabel?.heightAnchor.constraint(equalToConstant: textLabel!.frame.height).isActive = true
        
        textLabel?.frame = CGRect(x: 70, y: (textLabel!.frame.origin.y)-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
