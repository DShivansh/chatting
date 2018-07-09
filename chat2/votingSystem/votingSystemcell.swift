//
//  votingSystemcell.swift
//  chat2
//
//  Created by Shivansh Mishra on 18/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
class votingSystemCell:UICollectionViewCell{
    
    var controller:votingSystemController?
    
    let votingView:UIView = {
        let uv = UIView()
        uv.backgroundColor = .yellow
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
        
    }()
    
    
    lazy var likeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8-thumbs-up-50"), for: .normal)
        button.addTarget(self, action: #selector(self.likeButtonHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
//    lazy var likeSolidButton:UIButton = {
//        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "solidLikeButton"), for: .normal)
//        button.addTarget(self, action: #selector(self.solidLikeButtonHandler), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var dislikeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8-thumbs-down-50"), for: .normal)
        button.addTarget(self, action: #selector(self.dislikeButtonHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
//
//    lazy var dislikeSolidButton:UIButton = {
//
//        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "icons8-thumbs-down-filled-50"), for: .normal)
//        button.addTarget(self, action: #selector(self.dislikeSolidButtonHandler), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//
//    }()
    
    let text:UILabel = {
        let textLabel = UILabel()
        textLabel.text = "TESTING TESTING TESTING"
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let likeNumber:UILabel = {
        let textlabel = UILabel()
        textlabel.text = "0"
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        //textlabel.backgroundColor = .blue
        return textlabel
    }()
    
    let dislikeNumber:UILabel = {
        let textlabel = UILabel()
        textlabel.text = "0"
        textlabel.textAlignment = .right
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        //textlabel.backgroundColor = .blue
        return textlabel
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(votingView)
        votingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        votingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        votingView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        votingView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(likeButton)
        likeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        addSubview(likeSolidButton)
//        likeSolidButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
//        likeSolidButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
//        likeSolidButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        likeSolidButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        likeSolidButton.isHidden = true
        
        addSubview(dislikeButton)
        dislikeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        dislikeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        dislikeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        dislikeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        addSubview(dislikeSolidButton)
//        dislikeSolidButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
//        dislikeSolidButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
//        dislikeSolidButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        dislikeSolidButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        dislikeSolidButton.isHidden = true
        
        addSubview(text)
        text.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        text.topAnchor.constraint(equalTo: self.topAnchor, constant:10).isActive = true
        text.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: dislikeButton.leftAnchor).isActive = true
        
        addSubview(likeNumber)
        likeNumber.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        //likeNumber.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor).isActive = true
        likeNumber.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeNumber.widthAnchor.constraint(equalTo: likeButton.widthAnchor, multiplier: 2).isActive = true
        likeNumber.heightAnchor.constraint(equalTo: likeButton.heightAnchor)
        
        addSubview(dislikeNumber)
        dislikeNumber.rightAnchor.constraint(equalTo: dislikeButton.leftAnchor).isActive = true
        //likeNumber.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor).isActive = true
        dislikeNumber.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        dislikeNumber.widthAnchor.constraint(equalTo: likeButton.widthAnchor, multiplier: 2).isActive = true
        dislikeNumber.heightAnchor.constraint(equalTo: likeButton.heightAnchor)
        
    }
    
    @objc func likeButtonHandler(){
        //likeSolidButton.isHidden = false
        controller!.halfLikeButtonHandler(likeButton.tag,self)
        //print(likeButton.tag)
    }
    
//    @objc func solidLikeButtonHandler(){
//        likeSolidButton.isHidden = true
//        print(likeSolidButton.tag)
//    }
    
    @objc func dislikeButtonHandler(){
//        dislikeSolidButton.isHidden = false
        controller!.halfDislikeButtonHandler(dislikeButton.tag, self)
    }
    
//    @objc func dislikeSolidButtonHandler(){
//       dislikeSolidButton.isHidden = true
//        print(dislikeSolidButton.tag)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        self.likeButton.setImage(#imageLiteral(resourceName: "icons8-thumbs-up-50"), for: .normal)
        self.likeButton.isEnabled = true
        self.dislikeButton.setImage(#imageLiteral(resourceName: "icons8-thumbs-down-50"), for: .normal)
        self.dislikeButton.isEnabled = true
    }
    
    
    
    
}
