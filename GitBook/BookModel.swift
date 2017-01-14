//
//  BookModel.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import RealmSwift
// 本用のモデルクラス
class BookModel: Object{
    var book_id: Int?
    var book_url: String?
    var book_name: String?
    var book_image_url: String?
    var author: [String]?
    var comment: String?
    var tag: [String]?

}
