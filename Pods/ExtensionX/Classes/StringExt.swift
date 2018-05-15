//
//  StringExt.swift
//  ExtensionX
//
//  Created by GorXion on 2018/5/2.
//

public extension String {
    
    var isBlank: Bool {
        return isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var asNSString: NSString {
        return self as NSString
    }
    
    var asURL: URL? {
        return URL(string: self)
    }
    
    var asImage: UIImage? {
        return UIImage(named: self)
    }
}
