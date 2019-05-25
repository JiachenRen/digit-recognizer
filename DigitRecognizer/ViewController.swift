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
    var genericModel = MLModelManager.models[0] {
        didSet {
            setupCoreMLRequest()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        setupCoreMLRequest()
        updateModelLabel(genericModel.name)
    }
    
    private func setupCoreMLRequest() {
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: genericModel.coreMLModel) else {
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
        let description = genericModel.coreMLModel.modelDescription
        let inputDescription = description.inputDescriptionsByName["image"]
            ?? description.inputDescriptionsByName["data"]!
        let constraint = inputDescription.imageConstraint!
        
        let dim = CGSize(width: constraint.pixelsWide, height: constraint.pixelsHigh)
        
        // Scale the image
        var image = UIImage(view: canvasView)
            .scale(toSize: dim)
        
        // Invert the image if model requests it
        if genericModel.inverted {
            image = image.inverted()
        }
        
        var handler: VNImageRequestHandler
        if let ciImage = image.ciImage {
            // For inverted images
            handler = VNImageRequestHandler(ciImage: ciImage)
        } else {
            handler = VNImageRequestHandler(cgImage: image.cgImage!)
        }
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
            alert.addAction(UIAlertAction(title: model.name, style: .default) {[unowned self] action in
                self.genericModel = model
                self.updateModelLabel(action.title!)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
        })
        present(alert, animated: true)
    }
    
}
