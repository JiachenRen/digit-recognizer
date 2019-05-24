//
//  ViewController.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/23/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import UIKit
import Vision
import CoreImage

class ViewController: UIViewController, CanvasViewDelegate {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var predictionLabel: UILabel!
    var requests = [VNCoreMLRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        
        setupCoreMLRequest()
    }
    
    private func setupCoreMLRequest() {
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: DigitRecognizer().model) else {
            fatalError("can't load ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model, completionHandler: handleCoreMLRequest)
        self.requests = [request]
    }
    
    private func handleCoreMLRequest(_ request: VNRequest, _ error: Error?) {
        guard let results = request.results as? [VNClassificationObservation],
            let topResult = results.first else {
                fatalError("unexpected result type from VNCoreMLRequest")
        }
        
        DispatchQueue.main.async { [unowned self] in
            // Update prediction label
            if self.predictionLabel.text!.starts(with: "N/A") {
                self.predictionLabel.text = ""
            }
            self.predictionLabel.text! += topResult.identifier
        }
    }
    
    @IBAction func predictButtonTouched(_ sender: Any) {
        makePrediction()
    }
    
    /// Make prediction using what's drawn in the UIView as input image.
    func makePrediction() {
        
        // Scale and invert the image
        let image = UIImage(view: canvasView)
            .scale(toSize: CGSize(width: 28, height: 28))
            .inverted()
        
        let handler = VNImageRequestHandler(ciImage: image.ciImage!)
        DispatchQueue.global(qos: .userInteractive).async {[unowned self] in
            do {
                try handler.perform(self.requests)
            } catch {
                print(error)
            }
        }
    }

}
