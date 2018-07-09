//
//  sendMessageCell.swift
//  chat2
//
//  Created by Shivansh Mishra on 13/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import Foundation

import UIKit



class sendMessageCell:UITableViewCell{
    
    let LeftProfileImage:UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = #imageLiteral(resourceName: "gameofthrones_splash")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        //profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    let time:UILabel = {
        let timestamp = UILabel()
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        //timestamp.text = "TimeStamp"
        timestamp.font = UIFont.systemFont(ofSize: 12)
        return timestamp
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.addSubview(LeftProfileImage)
        LeftProfileImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        LeftProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        LeftProfileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        LeftProfileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.addSubview(time)
        time.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        time.topAnchor.constraint(equalTo: (self.textLabel?.topAnchor)!).isActive = true
        time.widthAnchor.constraint(equalToConstant: 100).isActive = true
        time.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 70, y: (textLabel!.frame.origin.y)-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        self.LeftProfileImage.image = #imageLiteral(resourceName: "gameofthrones_splash")
        
    }
    
    
    
    
    
    
    
    
}
