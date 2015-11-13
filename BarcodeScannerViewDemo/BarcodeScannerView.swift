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
    private var camPreviewLayer = AVCaptureVideoPreviewLayer()
    private let captureSession = AVCaptureSession()
    private let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.masksToBounds = true
        unhighlightedBorderColor = borderColor
        startCamera()
    }
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
    }
    
    private func startCamera() {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        videoOutput.videoSettings = nil
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(metaOutput)
        
        camPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        camPreviewLayer.frame = bounds
        camPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        /* 
        Modify the metadataObjectTypes to suit your specific needs. You should
        probably check what types are available to your device with this:
            println("\(metaOutput.metadataObjectTypes)")
        */
        
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]
        
        layer.addSublayer(camPreviewLayer)
        captureSession.startRunning()
        
        //camPreviewLayer!.connection.videoOrientation = videoOrientationForInterfaceOrientation()
    }
    
//    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        camPreviewLayer.connection.videoOrientation = videoOrientationForInterfaceOrientation()
//    }
//    
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
    
    private func didRecognizeBarcode(barcode: String) {
        delegate?.didRecognizeBarcode(barcode)
    }
    
    private func highlight() {
        if borderColor != UIColor.greenColor() {
            borderColor = UIColor.greenColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "unhighlight", userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    private func unhighlight() {
        borderColor = unhighlightedBorderColor!
    }
}