//
//  GenericMLModel.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/25/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation
import CoreML

class GenericMLModel {
    var name: String
    var inverted: Bool
    var coreMLModel: MLModel
    
    init(name: String, model: MLModel, inverted: Bool = true) {
        self.name = name
        self.inverted = inverted
        self.coreMLModel = model
    }
}
