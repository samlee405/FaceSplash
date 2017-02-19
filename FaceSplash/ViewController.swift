//
//  ViewController.swift
//  FaceSplash
//
//  Created by Sam Lee on 2/18/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var faces = [UIImage]()
    var currentFace: UIImage = #imageLiteral(resourceName: "will")
    
    let emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.birthRate = 0
        
        return emitter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let position = touches.first!.location(in: view)
        
        configureEmitter(x: position.x, y: position.y)
        resizeFace(face: currentFace, newWidth: 30)
        createCell()
    }
    
    func configureEmitter(x: CGFloat, y: CGFloat) {
        emitter.emitterPosition = CGPoint(x: x, y: y)
    }
    
    func resizeFace(face: UIImage, newWidth: CGFloat) {
        let scale = newWidth / face.size.width
        let newHeight = face.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        face.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        currentFace = newImage!
    }
    
    func createCell() {
        let cell = CAEmitterCell()
        
        cell.contents = currentFace.cgImage
        
        cell.birthRate = 5
        cell.lifetime = 12
        
        cell.velocity = 40
        cell.velocityRange = 30
        
        cell.emissionLongitude = .pi / 2 * 3
        cell.emissionRange = 2 * .pi
        
        cell.alphaRange = 0.5
        cell.alphaSpeed = -0.1
        
        cell.spin = 1.5
        cell.spinRange = 0.7
        
        cell.scaleRange = 0.5
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
//        cell.isEnabled = true
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(stopEmitter), userInfo: nil, repeats: false)
    }
    
    func stopEmitter() {
        print("stopEmitter is called")
//        emitter.emitterCells?[0].isEnabled = false
        emitter.birthRate = 0
    }
}

