//
//  loginScreen.swift
//  ChatSystemImplemetation
//
//  Created by Shivansh Mishra on 08/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase



class loginScreen: UIViewController {
    
    let theBox:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let nameBox:UITextField={
        let name = UITextField()
        name.placeholder = "Name"
        //name.backgroundColor = .red
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let line:UIView = {
        let lineMaker = UIView()
        lineMaker.backgroundColor = .black
        lineMaker.translatesAutoresizingMaskIntoConstraints = false
        return lineMaker
    }()
    
    let emailBox:UITextField = {
        let name = UITextField()
        name.placeholder = "Email"
        //name.backgroundColor = .red
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let line1:UIView = {
        
        let lineMaker = UIView()
        lineMaker.backgroundColor = .black
        lineMaker.translatesAutoresizingMaskIntoConstraints = false
        return lineMaker
        
    }()
    
    var changable:NSLayoutConstraint?
    var deletable:NSLayoutConstraint?
    var email:NSLayoutConstraint?
    var password:NSLayoutConstraint?
    
    
    let passwordBox:UITextField = {
        let name = UITextField()
        name.placeholder = "password"
        //name.backgroundColor = .red
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isSecureTextEntry = true
        return name
    }()
    
    let line2:UIView = {
        
        let lineMaker = UIView()
        lineMaker.backgroundColor = .black
        lineMaker.translatesAutoresizingMaskIntoConstraints = false
        return lineMaker
        
    }()
    
    lazy var SignImage:UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "gameofthrones_splash")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowingImagesToBePut)))
        return imageView
        
    }()
    
    
    
    
    let registerButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(checkingFirst), for: .touchUpInside)
        return button
    }()
    
    
    let registeredSegmented:UISegmentedControl = {
        let toggle = UISegmentedControl(items: ["Login", "Register"])
        toggle.tintColor = .white
        toggle.selectedSegmentIndex = 1
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(adjustingButton), for: .valueChanged)
        return toggle
    }()
    
    @objc func adjustingButton(){
        let titleName = registeredSegmented.titleForSegment(at: registeredSegmented.selectedSegmentIndex)
      changable?.constant =  registeredSegmented.selectedSegmentIndex == 1 ? 150 : 100
//        print(titleName)
        deletable?.isActive = false
        deletable = nameBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: registeredSegmented.selectedSegmentIndex == 1 ? 1/3 : 0)
        deletable?.isActive = true
        email?.isActive = false
        email = emailBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: registeredSegmented.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        email?.isActive = true
        password?.isActive = false
        password = passwordBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: registeredSegmented.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        password?.isActive = true
        registerButton.setTitle(titleName, for: .normal)
    }
    
    @objc func checkingFirst(){
        if registeredSegmented.selectedSegmentIndex == 1{
            RegisterButtonHandler()
        }else{
            SignInHandler()
        }
    }
    
    func SignInHandler(){
        //let reloadController = ViewController()
        //reloadController.handlingReloading()
        guard let email = emailBox.text, let password = passwordBox.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error)
                return
            }
            print("Successful signin happened")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func RegisterButtonHandler(){
        
        let reloadController = ViewController()
        //reloadController.handlingReloading()
        
        guard let email = emailBox.text, let password = passwordBox.text, let name = nameBox.text else {
            return
        }
        
      
        
     
        
       
        
        

        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{return}
            
            var  image:String?
            let uniqueName = NSUUID().uuidString
            let store = Storage.storage().reference(forURL: "gs://chatappimplementation.appspot.com/").child("images").child("\(uniqueName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.SignImage.image!, 0.1){
                store.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    print("\n")
                    print("HI fucking terminal i am going to print the metadata")
                    print(metadata?.downloadURL())
                    let image = metadata?.downloadURL()?.absoluteString
                    print(type(of: metadata?.downloadURL()))
                    settingImage(image!)
                                    })
            }
            
            func settingImage(_ setupvalue:String){
                image = setupvalue
                print(image)
                imageLocation()

            }
            
            
            func imageLocation(){
             guard let images = image else{print("husshhh i got no image")
                
                return}
            print("hi i am fucking images")
            print("\n")
            print(images)
            
            let ref:DatabaseReference!
            ref = Database.database().reference(fromURL: "https://chatappimplementation.firebaseio.com/")
            let userReference = ref.child("user")
            let unique = userReference.child(uid)
           
            print(images)
                let values = ["name":name, "email":email, "imageLocation":images, "authority":false] as [String : Any]
            unique.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                
                print("saved successfully in the database")
                self.dismiss(animated: true, completion: nil)
            })
           
            
            }}
        
     
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(theBox)
        theBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        theBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        theBox.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-24).isActive = true
        changable = theBox.heightAnchor.constraint(equalToConstant: CGFloat(150))
        changable?.isActive = true
        
        theBox.addSubview(nameBox)
        nameBox.leftAnchor.constraint(equalTo: theBox.leftAnchor).isActive = true
        nameBox.topAnchor.constraint(equalTo: theBox.topAnchor).isActive = true
        deletable = nameBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: 1/3)
        deletable?.isActive = true
        nameBox.widthAnchor.constraint(equalTo:theBox.widthAnchor).isActive = true
        
        theBox.addSubview(line)
        line.widthAnchor.constraint(equalTo: theBox.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.topAnchor.constraint(equalTo: nameBox.bottomAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: nameBox.leftAnchor).isActive = true
        
        
        theBox.addSubview(emailBox)
        emailBox.leftAnchor.constraint(equalTo: theBox.leftAnchor).isActive = true
        emailBox.topAnchor.constraint(equalTo: nameBox.bottomAnchor).isActive = true
        email =  emailBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: 1/3)
        email?.isActive = true
        emailBox.widthAnchor.constraint(equalTo:theBox.widthAnchor).isActive = true
        
        theBox.addSubview(line1)
        line1.widthAnchor.constraint(equalTo: theBox.widthAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line1.topAnchor.constraint(equalTo: emailBox.bottomAnchor).isActive = true
        line1.leftAnchor.constraint(equalTo: emailBox.leftAnchor).isActive = true
        
        theBox.addSubview(passwordBox)
        passwordBox.leftAnchor.constraint(equalTo: theBox.leftAnchor).isActive = true
        passwordBox.bottomAnchor.constraint(equalTo: theBox.bottomAnchor).isActive = true
        password = passwordBox.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: 1/3)
        password?.isActive = true
        passwordBox.widthAnchor.constraint(equalTo:theBox.widthAnchor).isActive = true
        
        theBox.addSubview(line2)
        line1.widthAnchor.constraint(equalTo: theBox.widthAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line1.topAnchor.constraint(equalTo: passwordBox.bottomAnchor).isActive = true
        line1.leftAnchor.constraint(equalTo: passwordBox.leftAnchor).isActive = true
        
        view.addSubview(registeredSegmented)
        registeredSegmented.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registeredSegmented.bottomAnchor.constraint(equalTo: theBox.topAnchor, constant:-12).isActive = true
        registeredSegmented.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-24).isActive = true
        registeredSegmented.heightAnchor.constraint(equalToConstant:36).isActive = true
        
        
        view.addSubview(SignImage)
        SignImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SignImage.bottomAnchor.constraint(equalTo: registeredSegmented.topAnchor, constant:-12).isActive = true
        SignImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        SignImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: theBox.bottomAnchor, constant: 12).isActive = true
        registerButton.heightAnchor.constraint(equalTo: theBox.heightAnchor, multiplier: 1/3).isActive = true
        registerButton.widthAnchor.constraint(equalTo: theBox.widthAnchor).isActive = true
        
        
    }
    
    
    
    
    
    
    
}

