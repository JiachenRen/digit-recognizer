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
    static let models: [GenericMLModel] = [
        .init(name: "99.7% MNIST", model: DigitRecognizer().model),
        .init(name: "CUSTOM 4-LAYER CNN MNIST", model: CustomDigitRecognizer().model),
        .init(name: "BASELINE 2-LAYER CNN MNIST", model: BaselineDigitRecognizer().model),
        .init(name: "51.5% CNN 100 SAMPLE", model: UselessDigitRecognizer().model),
        .init(name: "99.6% 5-LAYER 22000 EX", model: ExpandedDigitRecognizer().model),
    ]
}
