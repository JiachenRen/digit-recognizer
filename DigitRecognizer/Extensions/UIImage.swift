//
//  UIImage.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/24/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
    /**
     - Warning: causes the image to be blurry
     */
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    func scale(toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width , height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func inverted() -> UIImage {
        let coreImage = CIImage(cgImage: self.cgImage!)
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        return UIImage(ciImage: result)
    }
}
