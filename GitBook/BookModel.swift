//
//  BookModel.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import ObjectMapper
// 本用のモデルクラス
class BookModel: Mappable{
    var book_url: String?
    var book_name: String?
    var book_image_url: String?
    var author: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map){
        book_url <- map["book_url"]
        book_name <- map["book_name"]
        book_image_url <- map["book_image_url"]
        author <- map["author"]
    }
}
