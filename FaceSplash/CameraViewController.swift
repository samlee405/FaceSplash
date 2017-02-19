//
//  CameraViewController.swift
//  FaceSplash
//
//  Created by Sam Lee on 2/18/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var headShotWaterMark: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDualCamera, AVCaptureDeviceType.builtInTelephotoCamera, AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back)
        for device in (devices?.devices)! {
            if device.position == .back {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            previewLayer.frame = cameraView.bounds
                            
                            cameraView.layer.addSublayer(previewLayer)
                            
                            captureSession.startRunning()
                        }
                    }
                }
                catch {
                    print("Do some sick error handling")
                }
                
                break
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headShotWaterMark.layer.cornerRadius = 75
        takePhotoButton.layer.cornerRadius = 30
    }
    
    // MARK: - Take Photo

    @IBAction func takePhoto(_ sender: Any) {
        
        print("did press takePhoto button")
        sessionOutput.capturePhoto(with: AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG]), delegate: self)
    }

    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        processImageBuffer(sampleBuffer: photoSampleBuffer)
    }
    
    func processImageBuffer(sampleBuffer: CMSampleBuffer?) {
        if let unwrappedSampleBuffer = sampleBuffer {
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: unwrappedSampleBuffer, previewPhotoSampleBuffer: nil)
            let dataProvider = CGDataProvider(data: imageData as! CFData)
            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .right)
            let croppedImage = ImageHelper.sharedInstance.cropImage(uncroppedImage: image)
            
            ImageHelper.sharedInstance.images.append(croppedImage)
        }
        else {
            print("Video capture failed. Please try again")
        }
        
        
    }
}





