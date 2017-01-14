//
//  BookShelfModel.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import RealmSwift
// 本棚のモデルクラス
class BookShelfModel: Object{
    var shelf_id: Int?
    var shelf_name: String?
    var shelf_owner: String?
    var created_at: NSDate?
    var is_private: Bool?
    var shelf_books: [BookModel]?

}
