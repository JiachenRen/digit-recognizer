//
//  PadView.swift
//  DigitRecognizer
//
//  Created by Jiachen Ren on 5/23/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var lines = [Line]()
    var lineWidth: CGFloat = 10
    var color = UIColor.black
    
    var predictionTimer: Timer?
    var delegate: CanvasViewDelegate?
    
    override func draw(_ rect: CGRect) {
        color.set()
        for line in lines {
            let path = UIBezierPath()
            if line.points.count < 2 {
                let point = UIBezierPath(
                    ovalIn: CGRect(
                        center: line.points.first!,
                        size: CGSize(width: lineWidth * 2, height: lineWidth * 2)
                    )
                )
                point.fill()
                continue
            }
            var points = line.points
            path.move(to: points.removeFirst())
            while points.count % 3 != 0 {
                points.append(points.last!)
            }
            for i in stride(from: 0, to: points.count, by: 3) {
                path.addCurve(to: points[i + 2], controlPoint1: points[i], controlPoint2: points[i + 1])
            }
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.lineWidth = lineWidth
            path.stroke()
        }
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        predictionTimer?.invalidate()
        let line = Line(points: [])
        line.points.append(touch.location(in: self))
        lines.append(line)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let line = lines.last else {
            return
        }
        predictionTimer?.invalidate()
        line.points.append(touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        predictionTimer?.invalidate()
        predictionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {
            [unowned self] timer in
            self.scaleAndCenterDrawing()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {
                [unowned self] timer in
                self.delegate?.makePrediction()
                self.clearDrawing()
            }
        }
    }
    
    func clearDrawing() {
        lines = []
        setNeedsDisplay()
    }
    
    func findDrawingBounds(_ lines: [Line]) -> CGRect {
        var upperLeft = CGPoint(x: bounds.maxX, y: bounds.maxY)
        var lowerRight = bounds.origin
        lines.forEach {
            $0.points.forEach {
                upperLeft.x = upperLeft.x > $0.x ? $0.x : upperLeft.x
                upperLeft.y = upperLeft.y > $0.y ? $0.y : upperLeft.y
                lowerRight.x = lowerRight.x < $0.x ? $0.x : lowerRight.x
                lowerRight.y = lowerRight.y < $0.y ? $0.y : lowerRight.y
            }
        }
        
        // Calculate width and height of the drawing
        let w = lowerRight.x - upperLeft.x
        let h = lowerRight.y - upperLeft.y
        return CGRect(origin: upperLeft, size: CGSize(width: w, height: h))
    }
    
    /// Detects the area where the digit's been drawn, center the digit and scale to fit
    func scaleAndCenterDrawing() {
        let drawingBounds = findDrawingBounds(self.lines)
        let w = drawingBounds.width
        let h = drawingBounds.height
        let fillRatio: CGFloat = 0.7
        let longestSide = w > h ? w : h
        let desiredLength = bounds.width * fillRatio
        let scaleFactor = desiredLength / longestSide
        
        // Rescale the drawing to fit [fillRatio]% of canvas,
        // Simultaneously translate drawing to upper left corner of canvas
        var newLines = [Line]()
        newLines = lines.map {line in
            return Line(
                points: line.points.map {
                    return CGPoint(
                        x: ($0.x - drawingBounds.origin.x) * scaleFactor,
                        y: ($0.y - drawingBounds.origin.y) * scaleFactor
                    )
                }
            )
        }
        
        // Calculate the new origin for centering the scaled drawing
        let newDrawingBounds = findDrawingBounds(newLines)
        let newOriginX = (bounds.width - newDrawingBounds.width) / 2
        let newOriginY = (bounds.height - newDrawingBounds.height) / 2
        newLines.forEach {
            $0.translate(x: newOriginX, y: newOriginY)
        }
        
        // Translate the drawing onto the new, centered coordinate (animated)
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
            [unowned self] timer in
            self.lines.enumerated().forEach {(idx, line) in
                line.points = zip(line.points, newLines[idx].points).map {
                    (pos, dest) in
                    let relSpeed: CGFloat = 0.3
                    let deltaX = (dest.x - pos.x) * relSpeed
                    let deltaY = (dest.y - pos.y) * relSpeed
                    let dist = sqrt(pow(dest.x - pos.x, 2) + pow(dest.y - pos.y, 2))
                    if dist < 1 {
                        // Stop the loop when the lines align with their new position.
                        timer.invalidate()
                    }
                    // Smoothly translate each point in the old drawing to the its scaled translated position
                    return CGPoint(x: pos.x + deltaX, y: pos.y + deltaY)
                }
            }
            self.setNeedsDisplay()
        }
    }
    
    class Line {
        var points: [CGPoint]
        
        init(points: [CGPoint]) {
            self.points = points
        }
        
        func translate(x: CGFloat, y: CGFloat) {
            points = points.map {
                CGPoint(x: $0.x + x, y: $0.y + y)
            }
        }
    }

}

protocol CanvasViewDelegate {
    func makePrediction()
}
