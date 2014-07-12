#BarcodeScannerView
This is a quick-and-dirty custom view for scanning barcodes on iOS, written in Swift. The sample app will give you the gist of what's happening, but if you're feeling too lazy to even look at that:

+ Drop BarcodeScannerView.swift into your project.
+ Add a view to your storyboard and change the class to BarcodeScannerView.
+ Hook up your BarcodeScannerView to an outlet in your view controller.
+ Make your view controller a BarcodeScannerViewDelegate, assign the delegate property to your view controller and implement didRecognizeBarcode(barcode: String)

You'll almost certainly need to adjust the `metadataObjectTypes` to the kind of codes you want to scan. See the source code for instructions on getting the available object types.

#Notes
I threw this together from some old camera-related code I had written for another project in Objective-C. It's a little wonky and I probably made some mistakes. Keep that in mind before you use this for something important.
