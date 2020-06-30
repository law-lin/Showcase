//
//  Extensions.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/29/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit

let imgCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCache(urlString: String){
        
        // Check cache for card image
        if let cachedImage = imgCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // If cache doesn't have image, download it from Firebase Storage
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async{
                if let downloadedImage = UIImage(data: data!){
                    imgCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
                
            }
        }).resume()
    }
}
