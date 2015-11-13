//
//  ViewController.swift
//  BarcodeScannerViewDemo
//
//  Created by Richard Allen on 7/12/14.
//  Copyright (c) 2014 Richard Allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BarcodeScannerViewDelegate {
    
    @IBOutlet private weak var barcodeScannerView: BarcodeScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeScannerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didRecognizeBarcode(barcode: String) {
        print("\(barcode)")
    }

}
