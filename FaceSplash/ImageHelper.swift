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
        if face.size.width != 30 {
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
        let cropFrame = CGRect(x: 112, y: 258, width: 150, height: 150)
        let imageRef = uncroppedImage.cgImage?.cropping(to: cropFrame)
        let croppedImage = UIImage(cgImage: imageRef!)
        
        return croppedImage
    }
}
