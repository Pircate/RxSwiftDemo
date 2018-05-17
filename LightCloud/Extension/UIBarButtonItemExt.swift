//
//  UIBarButtonItemExt.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

extension UIBarButtonItem {
    
    convenience init(title: String?) {
        self.init(title: title, style: .plain, target: nil, action: nil)
    }
    
    convenience init(image: UIImage?) {
        self.init(image: image, style: .plain, target: nil, action: nil)
    }
}
