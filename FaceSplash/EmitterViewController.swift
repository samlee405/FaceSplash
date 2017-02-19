//
//  ViewController.swift
//  FaceSplash
//
//  Created by Sam Lee on 2/18/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import UIKit
import AVFoundation

class EmitterViewController: UIViewController {
    
    @IBOutlet weak var refreshImageButton: UIButton!
    
    var faces = [UIImage]()
    var currentFace: UIImage = #imageLiteral(resourceName: "will")
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initiating new animation
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let position = touches.first!.location(in: view)
        
        currentFace = ImageHelper.sharedInstance.resizeFace(face: currentFace, newWidth: 50)
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
            
            cell.birthRate = 4
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
            
            let roundedImage = ImageHelper.sharedInstance.roundedImage(image: currentFace, radius: 25)
            
            cell.contents = roundedImage.cgImage
            
            return cell
        }()
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        
        prepareToStopEmitter(emitter: emitter)
    }
    
    // MARK: - Removing animation
    
    func prepareToStopEmitter(emitter: CAEmitterLayer) {
        // Stop emitting particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.birthRate = 0
        }
        // Remove emitter from view.layer
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            emitter.removeFromSuperlayer()
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func test(_ sender: Any) {
        print("selecting new image")
        
        refreshImageButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        let count = ImageHelper.sharedInstance.images.count
        if count > 0 {
            currentFace = ImageHelper.sharedInstance.images[count - 1]
        }
    }
    
}


