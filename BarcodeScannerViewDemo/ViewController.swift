//
//  ViewController.swift
//  BarcodeScannerViewDemo
//
//  Created by Richard Allen on 7/12/14.
//  Copyright (c) 2014 Richard Allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BarcodeScannerViewDelegate {
    
    @IBOutlet var barcodeScannerView: BarcodeScannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        barcodeScannerView!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecognizeBarcode(barcode: String) {
        println("\(barcode)")
    }

}

