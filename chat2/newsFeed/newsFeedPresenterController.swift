//
//  newsFeedPresenterController.swift
//  chat2
//
//  Created by Shivansh Mishra on 26/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class newsFeedPresenterController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let cellID:String = "cellID"
    
    var feedInformation = [newsFeed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(newsFeedCells.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        loadingFeeds()
    }
    
    
    
    func loadingFeeds(){
        let ref = Database.database().reference().child("newsFeed")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let data = newsFeed()
                data.feedInformation = dictionary["description"] as? String
                data.heading = dictionary["heading"] as? String
                data.imageURL = dictionary["imageURL"] as? String
                data.height = dictionary["height"] as? Double
                self.feedInformation.append(data)
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(feedInformation.count)
        return feedInformation.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! newsFeedCells
        cell.heading.text = feedInformation[indexPath.item].heading
        cell.details.text = feedInformation[indexPath.item].feedInformation
        
        cell.image.loadingImageUsingCache(imageLocation: URL(string: feedInformation[indexPath.item].imageURL!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let descriptionString = (feedInformation[indexPath.item].description)
        let size = CGSize(width: collectionView.frame.width, height: 10000)
        let rectangle = NSString(string: feedInformation[indexPath.item].feedInformation!).boundingRect(with: size, options: .usesLineFragmentOrigin , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.5)], context: nil)
       let heightAdjustment = CGFloat(feedInformation[indexPath.item].height!)
        return CGSize(width: collectionView.frame.width, height: rectangle.height + heightAdjustment - 250)
    }
    
  
    
    
    
}
