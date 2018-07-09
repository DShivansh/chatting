//
//  chatLogController.swift
//  chat2
//
//  Created by Shivansh Mishra on 13/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import UIKit
import Firebase


class chatLogController:UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var naam:String?
    let cellID = "cellID"
    
    var presentableName:modleClass?{
        didSet{
            self.navigationItem.title = presentableName?.name
            print("hi i changed the value of presentable name")
            print(presentableName!)
            gettingmessages()
        }
    }
    
    var messages = [messagePropertiesAndData]()
    
    func gettingmessages(){
        let userID = Auth.auth().currentUser?.uid
        guard let ID = userID, let messageID = presentableName?.toId else{return}
        let ref = Database.database().reference().child("user-message").child(ID).child(messageID)
        let messageRef = Database.database().reference().child("message")
        ref.observe(.childAdded) { (snapshot) in
            let UniqueMessageIdentifier = snapshot.key
            let messageChildReference = messageRef.child(UniqueMessageIdentifier)
            messageChildReference.observeSingleEvent(of: .value, with: { (newSnapshot) in
                if let dictionary = newSnapshot.value as? [String:AnyObject]{
                    let messageContent = messagePropertiesAndData()
                    messageContent.fromId = dictionary["fromId"] as! String
                    messageContent.text = dictionary["text"] as? String
                    messageContent.timeStamp = dictionary["timeStamp"] as! Double
                    messageContent.toId = dictionary["toId"] as! String
                    messageContent.imageURL = dictionary["imageURL"] as? String
                    messageContent.imageWidth = dictionary["imageWidth"] as? NSNumber
                    messageContent.imageHeight = dictionary["imageHeight"] as? NSNumber
                    var messages123:String
                    
                    self.messages.append(messageContent)
                    
                    DispatchQueue.main.async {
                        print("123 mic testing")
                        self.collectionView?.reloadData()
                        let indexpath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexpath, at: .top, animated: true)
                    }
                    
                }
            })
        }
    }
    
    
    
    
    
    
    
    let bottomUIView:UIView = {
        let bottomview = UIView()
        //bottomview.backgroundColor = .red
        bottomview.translatesAutoresizingMaskIntoConstraints = false
        return bottomview
    }()
    
    let sendButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        //button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints  =  false
        button.addTarget(self, action: #selector(sendingMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var messageInput:UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
         textField.delegate = self
        //textField.backgroundColor = .blue
        return textField
    }()
    
    let line:UIView = {
        let bottomview = UIView()
        bottomview.backgroundColor = .red
        bottomview.translatesAutoresizingMaskIntoConstraints = false
        return bottomview
    }()
    
     lazy var chlaymydomonas:UILabel = {
        let title = UILabel()
        //title.text = "dfjslfjs"
        return title
    }()
    
    let uploadImage:UIImageView = {
       let uploadimage = UIImageView()
        uploadimage.image = #imageLiteral(resourceName: "upload_image_icon")
        uploadimage.translatesAutoresizingMaskIntoConstraints = false
        uploadimage.isUserInteractionEnabled = true
        
        return uploadimage
        
    }()
    
    @objc func showingImagePicker(){
        print("buttonWasPressed")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{

           uploadingImageFirebase(editedImage)

        }
        else if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{

            uploadingImageFirebase(image)

        }
        
        dismiss(animated: true, completion: nil)
       
    }
    
    func uploadingImageFirebase(_ image:UIImage){
        let uniqueImageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child("\(uniqueImageName).jpg")
        let uploadingImage = UIImageJPEGRepresentation(image, 0.20)
        if let uploadedImage = uploadingImage{
            ref.putData(uploadedImage, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                let imageURL = metadata?.downloadURL()?.absoluteString
                self.addingImageURLToDatabase(imageURL, image)
                
            }
        }
    }
    
    
    func addingImageURLToDatabase(_ URL:String?, _ image:UIImage){
        
        let ref = Database.database().reference().child("message")
        let uniqueRef = ref.childByAutoId()
        //print(presentableName?.toId)
        let toId = presentableName?.toId
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        guard let imageURL = URL else {return}
        let values = ["imageURL":imageURL, "toId":toId, "fromId":fromId, "timeStamp":timeStamp, "imageWidth":image.size.width, "imageHeight":image.size.height] as [String : Any]
        uniqueRef.updateChildValues(values)
        
        let fanningRef = Database.database().reference().child("user-message").child(fromId!).child(toId!)
        let newValues = [uniqueRef.key:1]
        fanningRef.updateChildValues(newValues)
        
        
        let recipientUserRef = Database.database().reference().child("user-message").child(toId!).child(fromId!)
        recipientUserRef.updateChildValues([uniqueRef.key:1])
        
        print(messageInput.text!)
        
        self.messageInput.text = ""
        
    }
    
    
    
    
    
    
    
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    var messageInputBottomAnchor:NSLayoutConstraint?
    
   
    

    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        // = "test log"
        
       

        
        
        //navigationItem.title = naam!
        print(presentableName)
        collectionView?.register(messagesCellCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 62, right: 0)
        
        
        
        collectionView?.backgroundColor = .white
        view.addSubview(bottomUIView)
        messageInputBottomAnchor = bottomUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageInputBottomAnchor?.isActive = true
        bottomUIView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomUIView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomUIView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomUIView.backgroundColor = .white
        
        bottomUIView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: bottomUIView.rightAnchor, constant:-5).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomUIView.bottomAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo:bottomUIView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: bottomUIView.widthAnchor, multiplier: 1/10)
        
        bottomUIView.addSubview(uploadImage)
        uploadImage.leftAnchor.constraint(equalTo: bottomUIView.leftAnchor).isActive = true
        uploadImage.bottomAnchor.constraint(equalTo: bottomUIView.bottomAnchor).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showingImagePicker)))
        
        bottomUIView.addSubview(messageInput)
        messageInput.leftAnchor.constraint(equalTo: uploadImage.rightAnchor).isActive = true
        messageInput.widthAnchor.constraint(equalTo: bottomUIView.widthAnchor, multiplier: 8/10).isActive = true
       messageInput.bottomAnchor.constraint(equalTo: bottomUIView.bottomAnchor).isActive = true
        messageInput.heightAnchor.constraint(equalTo: bottomUIView.heightAnchor).isActive = true
        
        view.addSubview(line)
        line.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomUIView.topAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        handlingKeyBoard()
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func handlingKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(gettingTheHeightOFTheKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(positioningOfMessages), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removingTheHeightOfTheKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func gettingTheHeightOFTheKeyboard(notification:Notification){
        let userInfo = notification.userInfo as! NSDictionary
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let frame = keyboardFrame.cgRectValue
        let animationTime = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        messageInputBottomAnchor?.constant = -frame.height
        
        UIView.animate(withDuration: animationTime) {
            self.view.layoutIfNeeded()
        }
        
       
        
        
    }
    
    @objc func removingTheHeightOfTheKeyboard(notification:Notification){
        let userInfo = notification.userInfo as! NSDictionary
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let frame = keyboardFrame.cgRectValue
        let animationTime = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        messageInputBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: animationTime) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func positioningOfMessages(){
        if messages.count > 0{
            let indexPath = IndexPath(item: messages.count-1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
   
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! messagesCellCollectionViewCell
        //cell.backgroundColor = .blue
        let messageText = messages[indexPath.item].text
        cell.textView.text = messageText
        settingCellProperties(indexPath, cell)
        cell.imageView.loadingImageUsingCache(imageLocation: URL(string: (presentableName?.profileImage)!))
        if let textMessage = messageText{
        cell.blueBubbleWidthAnchor.constant = calculatingTheApproximateHeight(textMessage).width+16
        }else if messages[indexPath.item].imageURL != nil{
            cell.blueBubbleWidthAnchor.constant = 200
        }
        cell.controllerReference = self
        return cell
    }
    
    func settingCellProperties(_ indexPath:IndexPath, _ cell:messagesCellCollectionViewCell){
        if messages[indexPath.item].fromId == Auth.auth().currentUser?.uid{
            cell.textView.isHidden = false
            cell.blueBubble.backgroundColor = .blue
            cell.textView.textColor = .white
            cell.imageView.isHidden = true
            cell.blueBubbleLeftAnchor.isActive = false
            cell.blueBubbleRightAnchor.isActive = true
        }else{
            cell.textView.isHidden = false
            cell.blueBubble.backgroundColor = .lightGray
            cell.textView.textColor = .black
            cell.imageView.isHidden = false
            cell.blueBubbleRightAnchor.isActive = false
            cell.blueBubbleLeftAnchor.isActive = true
        }
        
        if let image = messages[indexPath.item].imageURL{
            cell.blueBubble.backgroundColor = .clear
            cell.sendImage.loadingImageUsingCache(imageLocation: URL(string: image))
            cell.textView.isHidden = true
            
        }else{
            cell.sendImage.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 100
        if let messagesss = messages[indexPath.item].text{
            height = calculatingTheApproximateHeight(messagesss).height + 12
        }else if let imageHeight = messages[indexPath.item].imageHeight?.floatValue, let imageWidth = messages[indexPath.item].imageWidth?.floatValue{
            
            height =  CGFloat(imageHeight/imageWidth*200)
            
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func calculatingTheApproximateHeight(_ estimatedText:String) -> CGRect{
        
        let size = CGSize(width: 250, height: 10000)
        //let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
           return NSString(string: estimatedText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16.6)], context: nil)
        
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }
    
    
    
    
  
    


   
    

    
    @objc func sendingMessage(){
        
        let ref = Database.database().reference().child("message")
        let uniqueRef = ref.childByAutoId()
        //print(presentableName?.toId)
        let toId = presentableName?.toId
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values = ["text":messageInput.text!, "toId":toId, "fromId":fromId, "timeStamp":timeStamp] as [String : Any]
        uniqueRef.updateChildValues(values)
        
        let fanningRef = Database.database().reference().child("user-message").child(fromId!).child(toId!)
        let newValues = [uniqueRef.key:1]
        fanningRef.updateChildValues(newValues)
        
        
        let recipientUserRef = Database.database().reference().child("user-message").child(toId!).child(fromId!)
        recipientUserRef.updateChildValues([uniqueRef.key:1])
        
        print(messageInput.text!)
        
        self.messageInput.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendingMessage()
        return true
    }
    
    var printable:CGRect?
    var blackBackgroundColor:UIImageView?
    var selectedImage:UIImageView?
    
    func handlingZoom(_ imageSelected:UIImageView){
        print("I am running the logic of the zoom button")
            printable = imageSelected.superview?.convert(imageSelected.frame, to: nil)
            print(printable)
            let imageView = UIImageView(frame: printable!)
            imageView.backgroundColor = .red
            imageView.image = imageSelected.image
            imageView.isUserInteractionEnabled = true
            selectedImage = imageSelected
            
            
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOutHandler)))
            if let keyWindow = UIApplication.shared.keyWindow{
                
                blackBackgroundColor = UIImageView(frame: keyWindow.frame)
                blackBackgroundColor?.backgroundColor = .black
                blackBackgroundColor?.alpha = 0
                keyWindow.addSubview(blackBackgroundColor!)
                keyWindow.addSubview(imageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.blackBackgroundColor?.alpha = 1
                    let height = self.printable!.height/self.printable!.width * keyWindow.frame.width
                    
                    imageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    imageView.center = keyWindow.center
                }, completion: { (completed:Bool) in
                    //zoomOutView.removeFromSuperview()
                    //imageSelected.isUserInteractionEnabled = false
                })
                
//                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//                    self.blackBackgroundColor?.alpha = 1
//                    let height = self.printable!.height/self.printable!.width * keyWindow.frame.width
//
//                    imageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//                    imageView.center = keyWindow.center
//                }, completion: nil)
            }
            
        
    }
    
    @objc func zoomOutHandler(_ tapGesture:UITapGestureRecognizer){
        
        if let zoomOutView = tapGesture.view{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutView.layer.cornerRadius = 16
                zoomOutView.layer.masksToBounds = true
                zoomOutView.frame = self.printable!
                self.blackBackgroundColor?.alpha = 0
            }, completion: { (completed:Bool) in
                    zoomOutView.removeFromSuperview()
            })
        }
        
    }
    
}
