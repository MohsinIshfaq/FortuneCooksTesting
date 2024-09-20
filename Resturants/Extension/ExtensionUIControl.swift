//
//  ExtensionUIControl.swift
//  Resturants
//
//  Created by Mohsin on 20/09/2024.
//

import Foundation
import UIKit

protocol UIControlActionBlockSupport where Self: UIControl { }

extension UIControlActionBlockSupport {
    
    func addAction (for controlEvents: UIControl.Event = .touchUpInside, _ actionBlock: @escaping (Self) -> ()) {
        self.actionBlock = { [weak self] in
            if let me = self {
                actionBlock(me)
            }
        }
        removeTarget(nil, action: nil, for: .allEvents)
        addTarget(self, action: #selector(callActionBlock), for: controlEvents)
    }
    
    func addAction (for controlEvents: UIControl.Event = .touchUpInside, _ actionBlock: @escaping () -> ()) {
        self.actionBlock = {
            actionBlock()
        }
        removeTarget(nil, action: nil, for: .allEvents)
        addTarget(self, action: #selector(callActionBlock), for: controlEvents)
    }
    
    static func ==(control:Self, selector: Selector) {
        control.removeTarget(nil, action: nil, for: .allEvents)
        control.addTarget(nil, action: selector, for: .touchUpInside)
    }
    
    static func ==(control:Self, body:(target:Any, selector: Selector)) {
        control.removeTarget(nil, action: nil, for: .allEvents)
        control.addTarget(body.target, action: body.selector, for: .touchUpInside)
    }
    
    static func ==(control:Self, function: @escaping (Self) -> ()) {
        control.addAction(function)
    }
    
    static func ==(control:Self, function: @escaping () -> ()) {
        control.addAction(function)
    }
}

fileprivate extension UIControl {
    @IBAction func callActionBlock(_ button:UIControl) {
        actionBlock?()
    }
    
    var actionBlock: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionBlockKey) as? (() -> ())
        }
        set {
            objc_setAssociatedObject(self, &actionBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

private var actionBlockKey = 0

extension UIControl: UIControlActionBlockSupport {}

