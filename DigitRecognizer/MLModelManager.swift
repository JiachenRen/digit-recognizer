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
        .init(name: "89.4% 5-LAYER 22000 EX", model: ExpandedDigitRecognizer().model),
        .init(name: "84.5% 6-L 261-28710 LETTER", model: LetterRecognizer().model),
        .init(name: "93.8% 6-L 557-61270 LETTER", model: ImprovedLetterRecognizer().model),
        .init(name: "97.2% 5-L 87824 LETTER", model: BestLetterRecognizer().model),
    ]
}
