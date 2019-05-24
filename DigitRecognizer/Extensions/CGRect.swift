//
//  CGRect.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/24/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    init(center: CGPoint, size: CGSize){
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
}
