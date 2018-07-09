//
//  tabBarController.swift
//  chat2
//
//  Created by Shivansh Mishra on 18/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class customTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let chatController = UINavigationController(rootViewController: ViewController())
        chatController.title = "Chat"
        chatController.tabBarItem.image = #imageLiteral(resourceName: "icons8-chat-filled-50")
        
        let voteController = UINavigationController(rootViewController: votingSystemController(collectionViewLayout:UICollectionViewFlowLayout()))
        voteController.title = "Vote"
        voteController.tabBarItem.image = #imageLiteral(resourceName: "icons8-thumbs-up-down-filled-50-2")
        
        let newsController = UINavigationController(rootViewController: newsFeedPresenterController(collectionViewLayout: UICollectionViewFlowLayout()))
        newsController.title = "College News"
        newsController.tabBarItem.image = #imageLiteral(resourceName: "icons8-news-feed-50")
        
        
        let authority = UINavigationController(rootViewController: addingTheViews())
        authority.title = "Authority"
        authority.tabBarItem.image = #imageLiteral(resourceName: "icons8-administrator-male-50")
        
        FirebaseApp.configure()
        
//        if let currentUser = Auth.auth().currentUser?.uid{
//        
//            let ref = Database.database().reference().child("user").child(currentUser)
//            ref.observe(.value, with: { (snapshot) in
//                <#code#>
//            })
//        }
        
        if Auth.auth().currentUser?.uid == nil{
            loadnewViewController()
            
        }
        
        self.tabBar.tintColor = UIColor(red: 27/255, green: 0, blue: 1, alpha: 1)
        viewControllers = [chatController, voteController, newsController, authority]
    }
    
    @objc func loadnewViewController(){
        let loginViewController = loginScreen()
        present(loginViewController, animated: true, completion: nil)
    }
    
    
}
