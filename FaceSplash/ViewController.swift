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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initiating new animation
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let position = touches.first!.location(in: view)
        
        resizeFace(face: currentFace, newWidth: 30)
        configureEmitter(x: position.x, y: position.y)
    }
    
    func configureEmitter(x: CGFloat, y: CGFloat) {
        let emitter: CAEmitterLayer = {
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: x, y: y)
            emitter.beginTime = CACurrentMediaTime()
            
            return emitter
        }()
        
        configureCell(emitter: emitter)
    }
    
    func configureCell(emitter: CAEmitterLayer) {
        let cell: CAEmitterCell = {
            let cell = CAEmitterCell()
            
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
            
            cell.contents = currentFace.cgImage
            
            return cell
        }()
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        
        prepareToStopEmitter(emitter: emitter)
    }
    
    // MARK: - Removing animation
    
    func prepareToStopEmitter(emitter: CAEmitterLayer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emitter.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            emitter.removeFromSuperlayer()
        }
    }
    
    // MARK: - Other
    
    func resizeFace(face: UIImage, newWidth: CGFloat) {
        if face.size.width != 30 {
            let scale = newWidth / face.size.width
            let newHeight = face.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            
            face.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            currentFace = newImage!
        }
    }
}


