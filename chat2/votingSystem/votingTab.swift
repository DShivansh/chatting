//
//  votingTab.swift
//  chat2
//
//  Created by Shivansh Mishra on 19/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase

class votingTab: UIViewController {
    
    var array = [String]()
    
    
    let votingTitle:UITextField = {
        let label = UITextField()
        label.placeholder = "Enter the title of the vote...."
        label.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.red
        label.layer.borderColor = color.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var button:UIButton = {
        let button = UIButton()
        button.setTitle("Add Participants", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addingParticipants), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton()
        button.setTitle("Done adding participants!!!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(doneAddingVotes), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handlingTheCancel))
        
        view.addSubview(votingTitle)
        votingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        votingTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-100).isActive = true
        votingTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        votingTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: votingTitle.bottomAnchor, constant:5).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant:5).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    @objc func addingParticipants(){
        let participantAddingTab = additionOfVotingParticipants()
        //participantAddingTab.selectedUser = self.array
        participantAddingTab.mainViewController = self
        navigationController?.pushViewController(participantAddingTab, animated: true)
        
    }
    
    @objc func doneAddingVotes(){
        let ref = Database.database().reference().child("voting-ID")
        guard let uniqueID = Auth.auth().currentUser?.uid else{return}
        let uniqueRef = ref.childByAutoId()
        let timeStamp = NSDate().timeIntervalSince1970
        guard let name = votingTitle.text else {return}
        let like = 0
        let dislike = 0
        let values = ["timeStamp":timeStamp, "name":name, "like":like, "dislike":dislike] as [String:Any]
        uniqueRef.updateChildValues(values)
        
        let fanningRef = Database.database().reference().child("votingUser")
        for i in array{
            let addingRef = fanningRef.child(i).child(uniqueRef.key)
            let like = false
            let dislike = false
            let newValues = ["like":like, "dislike":dislike, "timeStamp":timeStamp] as [String:Any]
            addingRef.updateChildValues(newValues)

        }
        
        dismiss(animated: true) {
            self.votingTitle.text = ""
        }

    }
    
    @objc func handlingTheCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func assigningValuesToArr(_ new:[String]){
        array = new
        array.append((Auth.auth().currentUser?.uid)!)
    }
    
   
    
   
    
}
