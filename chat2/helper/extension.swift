//
//  extension.swift
//  chat2
//
//  Created by Shivansh Mishra on 13/12/17.
//  Copyright © 2017 Shivansh Mishra. All rights reserved.
//

import Foundation
import  UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadingImageUsingCache(imageLocation:URL?){
        
        if let cachedImage = imageCache.object(forKey: imageLocation as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        print("print something is not cool")
        
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(20)
            print("i have done something which i don't understand")
        }
        
        URLSession.shared.dataTask(with: imageLocation!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error)
            }
            guard let data = data else {return}
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data){
                    imageCache.setObject(downloadedImage, forKey: imageLocation as AnyObject)
                    self.image = downloadedImage
                }
                
               // self.image =
            }
            
            
        }).resume()
    }
    
}

