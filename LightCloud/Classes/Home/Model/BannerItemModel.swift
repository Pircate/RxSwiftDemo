//
//  BannerItemModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Foundation

struct BannerListModel: Codable {
    let topStories: [BannerItemModel]
    
    enum CodingKeys: String, CodingKey {
        case topStories = "top_stories"
    }
}

struct BannerItemModel: Codable {
    let id: String
    let title: String
    let image: String
}
