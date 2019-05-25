//
//  CoreMLModel.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/24/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation
import CoreML

class MLModelManager {
    static let models: [String: MLModel] = [
        "99.7% MNIST": DigitRecognizer().model,
        "CUSTOM 4-LAYER CNN MNIST": CustomDigitRecognizer().model,
        "BASELINE 2-LAYER CNN MNIST": BaselineDigitRecognizer().model
    ]
}
