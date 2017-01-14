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
    var bookURL: String?
    var bookName: String?
    var bookImageURL: String?
    var author: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map){
        bookURL <- map["bookURL"]
        bookName <- map["bookName"]
        bookImageURL <- map["bookImageURL"]
        author <- map["author"]
    }
}
