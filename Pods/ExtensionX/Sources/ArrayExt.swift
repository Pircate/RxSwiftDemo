//
//  ArrayExt.swift
//  ExtensionX
//
//  Created by GorXion on 2018/5/16.
//

public extension Array {
    
    func every(_ condition: (Element) -> Bool) -> Bool {
        for element in self {
            if !(condition(element)) {
                return false
            }
        }
        return true
    }
    
    func some(_ condition: (Element) -> Bool) -> Bool {
        for element in self {
            if condition(element) {
                return true
            }
        }
        return false
    }
    
    func group<T: Hashable>(by condition: (Element) -> T) -> [T: [Element]] {
        var result = [T: [Element]]()
        for element in self {
            let key = condition(element)
            if var values = result[key] {
                values.append(element)
                result.updateValue(values, forKey: key)
            }
            else {
                result.updateValue([element], forKey: key)
            }
        }
        return result
    }
}
