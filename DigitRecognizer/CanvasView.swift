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
            self.delegate?.makePrediction()
            self.lines = []
            self.setNeedsDisplay()
        }
    }
    
    class Line {
        var points: [CGPoint]
        
        init(points: [CGPoint]) {
            self.points = points
        }
    }

}

protocol CanvasViewDelegate {
    func makePrediction()
}
