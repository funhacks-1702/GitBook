//
//  BookShelfModel.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import ObjectMapper
// 本棚のモデルクラス
class BookShelfModel: Mappable{
    var shelf_id: Int?
    var shelf_name: String?
    var shelf_owner: String?
    var created_at: NSDate?
    var shelf_books: [BookModel]?
    
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
