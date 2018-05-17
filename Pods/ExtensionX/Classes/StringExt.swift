//
//  StringExt.swift
//  ExtensionX
//
//  Created by GorXion on 2018/5/2.
//

public extension String {
    
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

public extension String {
    
    var isBlank: Bool {
        return isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isEmail: Bool {
        return range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .regularExpression) != nil
    }
}

public extension String {
    
    func substring(from: Int, to: Int) -> String {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        return String(self[fromIndex..<toIndex])
    }
}
