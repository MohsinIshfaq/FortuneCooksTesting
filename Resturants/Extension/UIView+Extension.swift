//
//  UIView+Extension.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit

extension UIView {
    enum Corners: Int {
        case TopLeft = 0
        case TopRight
        case BottomLeft
        case BottomRight
        
        var cornerMask: CACornerMask {
            switch self {
            case .TopLeft:
                return .layerMinXMinYCorner
            case .TopRight:
                return .layerMaxXMinYCorner
            case .BottomLeft:
                return .layerMinXMaxYCorner
            case .BottomRight:
                return .layerMaxXMaxYCorner
            }
        }
    }
    
    @IBInspectable var isRounded: Bool {
        get { return layer.cornerRadius == frame.size.height * 0.5 }
        set {
            layer.cornerRadius = (newValue ? frame.size.height * 0.5 : 0)
            layer.masksToBounds = true
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func setCornerRadius(cornerRadius: Double = 5, corners:[Corners] = [])
    {
        if corners.count > 0 {
            if #available(iOS 11.0, *) {
                var cornerMask:CACornerMask = []
                for corner in corners {
                    cornerMask.insert(corner.cornerMask)
                }
                
                self.layer.maskedCorners = cornerMask
            }
        } else {
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = []
            } else {
                // Fallback on earlier versions
            }
        }
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(cornerRadius)
        
        
    }
    
    func setCornerRadius(cornerRadius: Double = 5)
    {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addSubview(_ controller: UIViewController) {
        if let mainController = parentViewController {
            mainController.addChild(controller)
            addSubview(controller.view)
            controller.didMove(toParent: mainController)
        } else {
            addSubview(controller.view)
        }
    }
}
