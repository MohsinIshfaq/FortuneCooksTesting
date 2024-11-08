//
//  UITableView+Extension.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

extension UITableView {
    
    func register(_ cellsName : String)
    {
        self.register(UINib.init(nibName: cellsName, bundle: nil), forCellReuseIdentifier: cellsName)
    }
    
    func register(_ cellsNames : [String])
    {
        cellsNames.forEach { self.register($0) }
    }
    
    func cell<T>(type: T.Type? = nil, for index: IndexPath? = nil) -> T where T: UITableViewCell {
        if let dict = value(forKey: "_nibMap") as? [String: UINib],dict.keys.contains(String(describing: T.self)) { } else {
            register(String(describing: T.self))
        }
        
        if let index = index {
            return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
        }
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
}
