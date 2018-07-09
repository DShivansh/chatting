//
//  votingSystemController.swift
//  chat2
//
//  Created by Shivansh Mishra on 18/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class votingSystemController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let votingCellID = "votingCellID"
    var votingArray = [votingCards]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "icons8-plus-math-50").withRenderingMode(.alwaysOriginal)
        self.collectionView?.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handlingTheAddButton))
        collectionView?.register(votingSystemCell.self, forCellWithReuseIdentifier: votingCellID)
        collectionView?.alwaysBounceVertical = true
        fetchingTheVotes()
    }
    
    @objc func handlingTheAddButton(){
        let votingSystemTab = votingTab()
        let tab = UINavigationController(rootViewController: votingSystemTab)
        present(tab, animated: true, completion: nil)
    }
    
    func fetchingTheVotes(){
        
        if let currentUser = Auth.auth().currentUser?.uid{
            let ref = Database.database().reference().child("votingUser").child(currentUser)
            let newRef = Database.database().reference().child("voting-ID")
            ref.observe(.childAdded, with: { (snapshot) in
                print("and the value of snapshot is\n \(snapshot.key)")
                
                newRef.observe(.childAdded, with: { (snapshotNew) in
                    if(snapshotNew.key == snapshot.key){
                        if let dicitionary = snapshotNew.value as? [String:AnyObject]{
                            let values = votingCards()
                            values.dislike = dicitionary["dislike"] as? Int
                            values.like = dicitionary["like"] as? Int
                            values.name = dicitionary["name"] as? String
                            values.timeStamp = dicitionary["timeStamp"] as? Double
                            values.voteID = snapshot.key
                            self.votingArray.append(values)
                            self.timer?.invalidate()
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handlingTheRefresh), userInfo: nil, repeats: false)
                          
                            
                        }
                    }
                })
                
            })
            
            
            
        }
    }
    
    
    var timer:Timer?
    
    @objc func handlingTheRefresh(){
     
        DispatchQueue.main.async {
            print("hi i did the reloading of the votes before selection")
            self.collectionView?.reloadData()
        }
        
        self.votingArray.sort { (v1, v2) -> Bool in
            return v1.timeStamp! > v2.timeStamp!
        }
        
    }
    
    



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return votingArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: votingCellID, for: indexPath) as! votingSystemCell
        cell.likeButton.tag = indexPath.item
        cell.controller = self
        
        
        let votingID = votingArray[indexPath.item].voteID
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("votingUser").child(currentUser!)
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                if((snapshot.key) == ((self.votingArray[indexPath.item].voteID)!)){
                    if (dictionary["like"] as! Bool){
                        print("hi i entered the dictionary like button and the value of the dictionary is \(dictionary["like"] as! Bool)")
                        cell.likeButton.setImage(#imageLiteral(resourceName: "solidLikeButton"), for: .normal)
                        cell.likeButton.isEnabled = false
                        cell.dislikeButton.isEnabled = false
                    }
                    else if(dictionary["dislike"] as! Bool){
                        cell.dislikeButton.setImage(#imageLiteral(resourceName: "icons8-thumbs-down-filled-50"), for: .normal)
                        cell.dislikeButton.isEnabled = false
                        cell.likeButton.isEnabled = false
                    }
                }
            }
        }
        
        cell.dislikeButton.tag = indexPath.item
        let arrayElement = votingArray[indexPath.item]
        cell.text.text = arrayElement.name
        if let like = arrayElement.like,let dislike = arrayElement.dislike{
        cell.likeNumber.text = "\(like)"
        cell.dislikeNumber.text = "\(dislike)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func halfLikeButtonHandler(_ number:Int, _ cell:votingSystemCell){
         let votingCardID = votingArray[number].voteID
            let userID = Auth.auth().currentUser?.uid
        votingArray[number].like = votingArray[number].like! + 1
        let ref = Database.database().reference().child("voting-ID").child(votingCardID!)
        let newRef = Database.database().reference().child("votingUser").child(userID!).child(votingCardID!)
        newRef.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                if (!(dictionary["like"] as! Bool)){
                    newRef.updateChildValues(["like":true])
                    cell.likeButton.setImage(#imageLiteral(resourceName: "solidLikeButton"), for: .normal)
                    cell.likeButton.isEnabled = false
                    cell.dislikeButton.isEnabled = false
                    print("yay i updated the like")
                }
            }
        }
        ref.updateChildValues(["like":votingArray[number].like!])
        time?.invalidate()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newRefresh), userInfo: nil, repeats: false)
        
    }
    
    func halfDislikeButtonHandler(_ number:Int,  _ cell:votingSystemCell){
        
        let votingCardID = votingArray[number].voteID
        let userID = Auth.auth().currentUser?.uid
        votingArray[number].dislike = votingArray[number].dislike! + 1
        let ref = Database.database().reference().child("voting-ID").child(votingCardID!)
        let newRef = Database.database().reference().child("votingUser").child(userID!).child(votingCardID!)
        newRef.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                if (!(dictionary["dislike"] as! Bool)){
                    newRef.updateChildValues(["dislike":true])
                    cell.dislikeButton.setImage(#imageLiteral(resourceName: "icons8-thumbs-down-filled-50"), for: .normal)
                    cell.dislikeButton.isEnabled = false
                    cell.likeButton.isEnabled = false
                    print("yay i updated the dislike")
                }
            }
        }
        ref.updateChildValues(["dislike":votingArray[number].dislike!])
        time?.invalidate()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newRefresh), userInfo: nil, repeats: false)
    }
    
  
    var time:Timer?
    
    
    
    @objc func newRefresh(){
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
   


    
    
}
