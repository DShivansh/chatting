//
//  additionOfVotingParticipants.swift
//  chat2
//
//  Created by Shivansh Mishra on 19/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase



class additionOfVotingParticipants: UITableViewController {
    let cellID = "cellID"
    
    
    var selectedUser = [String]()
    var displayedUser = [modleClass]()
    var mainViewController:votingTab?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let label = UIButton()
        label.setTitle("Done", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneButtonHandler))
        tableView.register(participantsCell.self, forCellReuseIdentifier: cellID)
        self.tableView.allowsMultipleSelection = true
        loadingTheUserData()
    }
    
    @objc func DoneButtonHandler(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainViewController!.assigningValuesToArr(selectedUser)
    }
    
   
    
   
    
  
    
    func loadingTheUserData(){
        let ref = Database.database().reference().child("user")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let data = modleClass()
                data.email = dictionary["email"] as? String
                data.name = dictionary["name"] as? String
                data.profileImage = dictionary["imageLocation"] as? String
                data.toId = snapshot.key
                self.displayedUser.append(data)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! participantsCell
        let allUserData = displayedUser[indexPath.row]
        cell.textLabel?.text = allUserData.name!
        cell.LeftProfileImage.loadingImageUsingCache(imageLocation: URL(string: allUserData.profileImage!))
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser.append(displayedUser[indexPath.row].toId!)
        print(selectedUser)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedUser = selectedUser.filter {$0 != displayedUser[indexPath.row].toId!}
        print(selectedUser)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    
    
}
