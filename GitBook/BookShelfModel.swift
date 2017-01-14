//
//  BookShelfModel.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import ObjectMapper

class BookShelfModel: Mappable{
    var ShelfId: Int?
    var ShelfName: String?
    var ShelfOwner: String?
    var CreatedAt: NSDate?
    var ShelfBooks: [BookModel]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        ShelfId <- map["ShelfId"]
        ShelfName <- map["ShelfName"]
        ShelfOwner <- map["ShelfOwner"]
        CreatedAt <- map["CreatedAt"]
        ShelfBooks <- map["ShelfBooks"]
    }
}
