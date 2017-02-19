//
//  ImageHelper.swift
//  FaceSplash
//
//  Created by Sam Lee on 2/18/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    static var sharedInstance = ImageHelper()
    
    var images = [UIImage]()
    
    func resizeFace(face: UIImage, newWidth: CGFloat) -> UIImage {
        if face.size.width != newWidth {
            let scale = newWidth / face.size.width
            let newHeight = face.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            
            face.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            
            return newImage!
        }
        
        return face
    }
    
    func cropImage(uncroppedImage: UIImage) -> UIImage {
        let cropFrame = CGRect(x: 600, y: 400, width: 410, height: 400)
        
        let imageRef = uncroppedImage.cgImage?.cropping(to: cropFrame)
        let croppedImage = UIImage(cgImage: imageRef!)
        
        return croppedImage
    }
    
    func roundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
}
