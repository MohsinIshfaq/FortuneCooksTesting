//
//  Array+Extension.swift
//  Resturants
//
//  Created by Mohsin on 18/09/2024.
//

import Foundation

extension Array {
    
    @discardableResult
    mutating func removeFirst(where block:(Element)->Bool) -> Index? {
        guard let index = firstIndex(where: block) else { return nil }
        remove(at: index)
        return index
    }
    
}
