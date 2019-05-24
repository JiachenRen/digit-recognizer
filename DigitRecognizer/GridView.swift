//
//  GridView.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/24/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import UIKit

@IBDesignable
class GridView: UIView {
    private var path = UIBezierPath()
    
    fileprivate var gridWidthMultiple: CGFloat {
        return 10
    }
    
    fileprivate var gridHeightMultiple : CGFloat {
        return 10
    }
    
    fileprivate var gridWidth: CGFloat {
        return bounds.width / CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat {
        return bounds.height / CGFloat(gridHeightMultiple)
    }
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid() {
        path = UIBezierPath()
        path.lineWidth = 1.0
        
        for index in 1...Int(gridWidthMultiple) - 1 {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        
        for index in 1...Int(gridHeightMultiple) - 1 {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridHeight)
            let end = CGPoint(x: bounds.width, y: CGFloat(index) * gridHeight)
            path.move(to: start)
            path.addLine(to: end)
        }
        
        path.close()
    }
    
    override func draw(_ rect: CGRect) {
        drawGrid()
        
        // Specify a border (stroke) color.
        UIColor.lightGray.setStroke()
        path.stroke()
        
        layer.mask = createGradientLayer(
            from: CGPoint(x: 0.5, y: 0),
            to: CGPoint(x: 0.5, y: 1)
        )
    }
    
    private func createGradientLayer(from startPoint: CGPoint, to endPoint: CGPoint) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        let whiteColor = UIColor.white
        gradient.colors = [
            whiteColor.withAlphaComponent(0.0).cgColor,
            whiteColor.withAlphaComponent(1.0).cgColor,
            whiteColor.withAlphaComponent(1.0).cgColor,
            whiteColor.withAlphaComponent(0.0).cgColor
        ]
        gradient.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: 0.2),
            NSNumber(value: 0.8),
            NSNumber(value: 1.0)
        ]
        gradient.frame = bounds
        return gradient
    }
    
}
