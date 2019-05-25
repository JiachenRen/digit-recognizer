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
    @IBOutlet weak var modelNameLabel: UILabel!
    
    var requests = [VNCoreMLRequest]()
    var coreMLModel = CustomDigitRecognizer().model {
        didSet {
            setupCoreMLRequest()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        setupCoreMLRequest()
    }
    
    private func setupCoreMLRequest() {
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: coreMLModel) else {
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
            self.predictionLabel.text! = topResult.identifier
        }
    }
    
    /// Make prediction using what's drawn in the UIView as input image.
    func makePrediction() {
        
        // Figure out the model input dimensions
        let constraint = coreMLModel.modelDescription
            .inputDescriptionsByName["image"]!
            .imageConstraint!
        
        let dim = CGSize(width: constraint.pixelsWide, height: constraint.pixelsHigh)
        
        // Scale and invert the image
        let image = UIImage(view: canvasView)
            .scale(toSize: dim)
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
    
    private func updateModelLabel(_ newModelName: String) {
        modelNameLabel.text = newModelName
    }
    
    @IBAction func changeModelButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select CoreML Model", message: nil, preferredStyle: .actionSheet)
        MLModelManager.models.forEach {model in
            alert.addAction(UIAlertAction(title: model.key, style: .default) {[unowned self] action in
                self.coreMLModel = model.value
                self.updateModelLabel(action.title!)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
        })
        present(alert, animated: true)
    }
    
}
