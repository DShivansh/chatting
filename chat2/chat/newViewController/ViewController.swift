//
//  ViewController.swift
//  ChatSystemImplemetation
//
//  Created by Shivansh Mishra on 08/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    var messages = [messagePropertiesAndData]()
    var messageDictionary = [String:messagePropertiesAndData]()
    let cellID = "cellID"
   // var displayChatText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        let ref = Firebase.Database().reference(fromURL: "https://chattingapp-4d8e2.firebaseio.com/")
        //        ref.updateChildValues(["honey":123])
        
        
        
        let button = UIButton()
        button.setTitle("SignOut", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target:self , action: #selector(newMessage))
        
        if Auth.auth().currentUser?.uid == nil{
            loadnewViewController()
            
        }
        
        tableView.register(sendMessageCell.self, forCellReuseIdentifier: cellID)
        
        
        
        
        
        
        
    }
    
    
    func showMessageToBeDisplayed(){
        
        print("hi i am inside showmessagetobedisplayed")
        if let userId = Auth.auth().currentUser?.uid{
        let user_messageRef = Database.database().reference().child("user-message").child(userId)
        user_messageRef.observe(.childAdded) { (snapshot) in
            let refNew = user_messageRef.child(snapshot.key)
            refNew.observe(.childAdded, with: { (newSnapshot) in
                self.observeMessage(newSnapshot.key)
            })
            }
            
        }
        
    }
    
    
    
    
    
    
    func observeMessage(_ childValue:String){
      
        
       Database.database().reference().child("message").child(childValue).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                var messageData = messagePropertiesAndData()
                messageData.toId = dictionary["toId"] as! String
                messageData.text = dictionary["text"] as? String
                messageData.fromId = dictionary["fromId"] as! String
                messageData.timeStamp = dictionary["timeStamp"] as! Double
                
                //self.messages.append(messageData)
                
                var idSelector:String
                
                if(messageData.toId! == Auth.auth().currentUser?.uid){
                    idSelector = messageData.fromId!
                }else{
                    idSelector = messageData.toId!
                }
                
                
                
                self.messageDictionary[idSelector] = messageData
              
                
               self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                
                
            }
            //print(self.arr)
        }
        
      
        
        
    }
    
    var timer:Timer?

    @objc func handleReloadTable(){
        
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timeStamp! > m2.timeStamp!
        })
        
        DispatchQueue.main.async {
            print("reload called")
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        //imageCache.removeAllObjects()
        showMessageToBeDisplayed()
        
        
        
        let ref = Database.database().reference(fromURL: "https://chatappimplementation.firebaseio.com/")
        
        //let uid = Auth.auth().currentUser?.uid
        guard let uid =  Auth.auth().currentUser?.uid else {
            return
        }
        ref.child("user").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                
                
                
                // self.navigationItem.title =
                
                let view1 = UIView()
                view1.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                view1.backgroundColor = .red
                
                let lable = UILabel()
                lable.text = value["name"] as? String
                view1.addSubview(lable)
                lable.translatesAutoresizingMaskIntoConstraints = false
                lable.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
                lable.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
                lable.widthAnchor.constraint(equalTo: view1.widthAnchor,constant:-10).isActive = true
                lable.heightAnchor.constraint(equalTo: view1.heightAnchor, constant:-10).isActive = true
                
                self.navigationItem.titleView = view1
                
                
                //view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.newView)))
            }
        }
        
        
        
    }
    
    func newView (_ nameUser: modleClass){
        let loginController = chatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        loginController.presentableName = nameUser
        loginController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loginController, animated: true)
        
        
    }
    
    @objc func newMessage(){
        print("new message button was pressed")
        let messagePresenter = messageController()
        let rootview = UINavigationController(rootViewController:(messagePresenter))
        messagePresenter.viewCont = self
        present(rootview, animated: true, completion: nil)
    }
    
    @objc func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
        loadnewViewController()
    }
    
    @objc func loadnewViewController(){
        let loginViewController = loginScreen()
        present(loginViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! sendMessageCell
        
        var idSelector:String
        
        if(messages[indexPath.row].toId! == Auth.auth().currentUser?.uid){
            idSelector = messages[indexPath.row].fromId!
        }else{
            idSelector = messages[indexPath.row].toId!
        }
        
        
        
        
        let ref = Database.database().reference().child("user").child(idSelector)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                cell.textLabel?.text = dictionary["name"] as! String
                let imageLocation = URL(string: dictionary["imageLocation"]! as! String)
                cell.LeftProfileImage.loadingImageUsingCache(imageLocation: imageLocation)
            }
        }
        
        
        
        //cell.textLabel?.text = messages[indexPath.row].toId
        cell.detailTextLabel?.text = messages[indexPath.row].text
        if messages[indexPath.row].text == nil{
             cell.detailTextLabel?.text = "Sent an image..."
        }
        let timeStampDate = NSDate(timeIntervalSince1970: messages[indexPath.row].timeStamp!)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm:ss a"
        cell.time.text =  dateformatter.string(from: timeStampDate as Date)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var idSelector:String
        
        if(messages[indexPath.row].toId! == Auth.auth().currentUser?.uid){
            idSelector = messages[indexPath.row].fromId!
        }else{
            idSelector = messages[indexPath.row].toId!
        }
        
        let referenceToUser = Database.database().reference().child("user").child(idSelector)
        referenceToUser.observeSingleEvent(of: .value) { (snapshot) in
            
            
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                var userData = modleClass()
                
                
                userData.name = dictionary["name"] as! String
                userData.email = dictionary["email"] as! String
                userData.profileImage = dictionary["imageLocation"] as! String
                userData.toId = idSelector
                self.newView(userData)
                
            }
            
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    
    
}

