//
//  BarcodeScannerView.swift
//  UPC
//
//  Created by Richard Allen on 7/10/14.
//  Copyright (c) 2014 Lapdog. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeScannerViewDelegate {
    func didRecognizeBarcode(barcode: String)
}

@IBDesignable
class BarcodeScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var delegate: BarcodeScannerViewDelegate?
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blueColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 5.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var unhighlightedBorderColor: UIColor?
    var camPreviewLayer: AVCaptureVideoPreviewLayer?
    let captureSession = AVCaptureSession()
    let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        layer.masksToBounds = true
        unhighlightedBorderColor = borderColor
        startCamera()
    }
    
    init(frame: CGRect)  {
        super.init(frame: frame)
    }
    
    func startCamera() {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        
        var error: NSError? = nil
        let videoInput = AVCaptureDeviceInput(device: videoCaptureDevice, error: &error)
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        let queue = dispatch_queue_create("backQueue", nil)
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        
        videoOutput.videoSettings = NSDictionary(object: kCVPixelFormatType_32BGRA, forKey: kCVPixelBufferPixelFormatTypeKey)
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(metaOutput)
        
        camPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        camPreviewLayer!.frame = bounds
        camPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        /* Modify the metadataObjectTypes to suit your specific needs. You should 
        probably check what types are available to your device with this: */
        
        //println("\(metaOutput.metadataObjectTypes)")
        
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]
        
        layer.addSublayer(camPreviewLayer!)
        captureSession.startRunning()
        
        //camPreviewLayer!.connection.videoOrientation = videoOrientationForInterfaceOrientation()
    }
    
//    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        camPreviewLayer!.connection.videoOrientation = videoOrientationForInterfaceOrientation()
//    }
    
//    func videoOrientationForInterfaceOrientation() -> AVCaptureVideoOrientation {
//        switch interfaceOrientation {
//        case UIInterfaceOrientation.LandscapeLeft:
//            return AVCaptureVideoOrientation.LandscapeLeft
//        case UIInterfaceOrientation.LandscapeRight:
//            return AVCaptureVideoOrientation.LandscapeRight
//        case UIInterfaceOrientation.Portrait:
//            return AVCaptureVideoOrientation.Portrait
//        case UIInterfaceOrientation.PortraitUpsideDown:
//            return AVCaptureVideoOrientation.PortraitUpsideDown
//        default:
//            return AVCaptureVideoOrientation.Portrait
//        }
//    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects.count > 0 {
            highlight()
        }
        
        for object in metadataObjects {
            didRecognizeBarcode(object.stringValue)
        }
    }
    
    func didRecognizeBarcode(barcode: String) {
        delegate?.didRecognizeBarcode(barcode)
    }
    
    func highlight() {
        if borderColor != UIColor.greenColor() {
            borderColor = UIColor.greenColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "unhighlight", userInfo: nil, repeats: false)
        }
    }
    
    func unhighlight() {
        borderColor = unhighlightedBorderColor!
    }
}