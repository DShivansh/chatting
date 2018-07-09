//
//  messageController.swift
//  chat2
//
//  Created by Shivansh Mishra on 11/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class messageController: UITableViewController {
    
    
    let cellID = "cellID"
    var arr = [modleClass]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(sendMessageCell.self, forCellReuseIdentifier: cellID)
        
        fetchUser()
    }
    @objc func handleCancel(){
        print("the cancle button was pressed")
        dismiss(animated: true, completion: nil)
    }
    
    
    func fetchUser(){
        Database.database().reference().child("user").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                var user = modleClass()
                user.toId = snapshot.key
                user.email = dictionary["email"] as! String
                user.name = dictionary["name"] as! String
                user.profileImage = dictionary["imageLocation"] as? String
                self.arr.append(user)
                self.tableView.reloadData()
                
            }
            print(self.arr)
        }

        
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arr.count)
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell  = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! sendMessageCell
        let users = arr[indexPath.row]
        cell.textLabel?.text = users.name
        cell.detailTextLabel?.text = users.email
        //cell.imageView?.image = #imageLiteral(resourceName: "new_message_icon")
        //cell.imageView?.contentMode = .scaleAspectFill
        if let profileImage = users.profileImage{
            let url = URL(string: profileImage)
            //print(url)

//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                print("hi i entered the urlSession")
//                if error != nil{
//                    print(error)
//                }
//                print("i am data \(data!)")
//                DispatchQueue.main.async {
////                    cell.leftProfileImage.image = UIImage(data: data!)
//                }
//
//
//            }).resume()
            if let urlToBePassed = url{
            cell.LeftProfileImage.loadingImageUsingCache(imageLocation: urlToBePassed)
            }

        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 500
//    }
    
//
    
    var viewCont:ViewController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       

        dismiss(animated: true) {
            self.viewCont?.newView(self.arr[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

  

}
