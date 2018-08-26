//
//  UIBezier+Arrow.swift
//  TaskTape AR Features
//
//  Created by Chris Mathias on 8/19/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//
import UIKit

//https://gist.github.com/mwermuth/07825df27ea28f5fc89a
//extension UIBezierPath {
//
//    class func getAxisAlignedArrowPoints(points: inout Array<CGPoint>, forLength: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat ) {
//
//        let tailLength = forLength - headLength
//        points.append(CGPoint(x: 0, y: tailWidth/2))
//        points.append(CGPoint(x: tailLength, y: tailWidth/2))
//        points.append(CGPoint(x: tailLength, y: headWidth/2))
//        points.append(CGPoint(x: forLength, y: 0))
//        points.append(CGPoint(x: tailLength, y: -headWidth/2))
//        points.append(CGPoint(x: tailLength, y: -tailWidth/2))
//        points.append(CGPoint(x: 0, y: -tailWidth/2))
//
//    }
//
//
//    class func transformForStartPoint(startPoint: CGPoint, endPoint: CGPoint, length: CGFloat) -> CGAffineTransform{
//        let cosine: CGFloat = (endPoint.x - startPoint.x)/length
//        let sine: CGFloat = (endPoint.y - startPoint.y)/length
//
//        return CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: startPoint.x, ty: startPoint.y)
//    }
//
//
//    class func bezierPathWithArrowFromPoint(startPoint:CGPoint, endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
//
//        let xdiff: Float = Float(endPoint.x) - Float(startPoint.x)
//        let ydiff: Float = Float(endPoint.y) - Float(startPoint.y)
//        let length = hypotf(xdiff, ydiff)
//
//        var points = [CGPoint]()
//        self.getAxisAlignedArrowPoints(points: &points, forLength: CGFloat(length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
//
//        let transform: CGAffineTransform = self.transformForStartPoint(startPoint: startPoint, endPoint: endPoint, length:  CGFloat(length))
//
//        let cgPath: CGMutablePath = CGMutablePath()
//        cgPath.addLines(between: [startPoint, endPoint], transform: transform)
//        cgPath.closeSubpath()
//
//        let uiPath: UIBezierPath = UIBezierPath(cgPath: cgPath)
//        return uiPath
//    }
//}

import UIKit

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform )
        path.closeSubpath()
        return self.init(cgPath: path)
    }
    
}

