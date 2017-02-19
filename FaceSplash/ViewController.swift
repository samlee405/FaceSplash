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
    
    var emitters: [CAEmitterLayer] = []
    var emitterIndex = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeEmitters()
    }
    
    // MARK: - Initializers
    
    func initializeEmitters() {
        for _ in 0...9 {
            let emitter: CAEmitterLayer = {
                let emitter = CAEmitterLayer()
                emitter.birthRate = 0
            
                return emitter
            }()

            emitters.append(emitter)
        }
    }
    
    // MARK: - Initiating new animation
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let position = touches.first!.location(in: view)
        
        resizeFace(face: currentFace, newWidth: 30)
        configureEmitter(x: position.x, y: position.y)
        configureCell()
        prepareToStopEmitter()
    }
    
    func configureEmitter(x: CGFloat, y: CGFloat) {
        emitters[emitterIndex].emitterPosition = CGPoint(x: x, y: y)
        emitters[emitterIndex].birthRate = 1
        emitters[emitterIndex].beginTime = CACurrentMediaTime()
    }
    
    func configureCell() {
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
        
        emitters[emitterIndex].emitterCells = [cell]
        view.layer.addSublayer(emitters[emitterIndex])
    }
    
    // MARK: - Removing animation
    
    func prepareToStopEmitter() {
        let index = self.emitterIndex
        print(index)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print(index)
            self.emitters[index].birthRate = 0
            
            // increment the index to use next emitter
            self.updateEmitterIndex()
        }
        print(Date())
//        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(stopEmitter(timer:)), userInfo: ["parameter" : Date()], repeats: false)
    }
    
    func stopEmitter(timer: Timer) {


        
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
    
    func updateEmitterIndex() {
        emitterIndex = (emitterIndex + 1) % 10
    }
}


