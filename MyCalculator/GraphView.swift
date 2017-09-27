//
//  GraphView.swift
//  MyCalculator
//
//  Created by Joon on 20/09/2017.
//  Copyright © 2017 Joon. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 1.0
    
    var formattedCoordinate: CGPoint = CGPoint()
    var coordinate: CGPoint {
        get {
            return formattedCoordinate
        }
        set {
            formattedCoordinate = CGPoint(x: newValue.x + pointOffset.x, y: pointOffset.y - newValue.y)
        }
    }
    var pointOffset: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }


    func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        
        coordinate = CGPoint(x: x * scale, y: y * scale)
        return coordinate
    }
    
    enum MethodOfDrawingLine {
        
    }
    
    enum Direction {
        case vertical
        case horizontal
    }
    
    func drawLine(path: UIBezierPath, from start: CGPoint, through way: MethodOfDrawingLine, directionBy: Direction) -> UIBezierPath {
        
        
        
        return path
    }

    func pathForXLine() -> UIBezierPath {
        let start = CGPoint(x: 0,y: bounds.midY)
        let end = CGPoint(x: bounds.maxX, y: bounds.midY)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
    
        return path
    }
    
    func pathForYLine() -> UIBezierPath {
        let start = CGPoint(x: bounds.midX, y: 0)
        let end = CGPoint(x: bounds.midX, y: bounds.maxY)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        return path
    }
    
    func drawLine(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
       
        return path
    }
    
    func drawSin() -> UIBezierPath {
        let path = UIBezierPath()
        
        let minX = -2 * Double.pi
        let maxX =  2 * Double.pi
        let origin = point(CGFloat(minX), CGFloat(sin(minX)))
        path.move(to: origin)
        
        for x in stride(from: minX, to: maxX, by: 0.1) {
            let divisionX = CGFloat(x)
            let divisionY = CGFloat(sin(x))
            print(divisionY)
            print(divisionX)
            
            path.addLine(to: point(divisionX, divisionY))
        }
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        pathForXLine().stroke()
        pathForYLine().stroke()
//        drawLine(from: point(0,0), to: point(-100,100)).stroke()
        drawSin().stroke()
    }
    

}
