//
//  FaceView.swift
//  FaceIt
//
//  Created by Easer Liu on 15/11/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9
    @IBInspectable
    var eyesOpen: Bool = true
    @IBInspectable
    var mouthCurvature: CGFloat = 1.0
    @IBInspectable
    var lineWith: CGFloat = 5.0
    
    private var skullRadius : CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter : CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye{
        case left
        case right
    }
    private func pathForEye(_ eye: Eye) -> UIBezierPath{
        func centerOfEye(_ eye: Eye) -> CGPoint{
            let  eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1:1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        let path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        }else{
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        
        path.lineWidth = lineWith
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = max(-1, min(mouthCurvature, 1)) * mouthRect.height
        let start: CGPoint = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end: CGPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp0: CGPoint = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp1: CGPoint = CGPoint(x: end.x - mouthRect.width / 3, y: end.y + smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp0, controlPoint2: cp1)
        path.lineWidth = lineWith
        return path
    }
    
    private func pathForSkull() -> UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWith
        return path
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
 
    private struct Ratios{
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }

}
