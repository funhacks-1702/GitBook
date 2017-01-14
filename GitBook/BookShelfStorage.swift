//
//  BookShelfStorage.swift
//  GitBook
//
//  Created by Yuta on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import RealmSwift

class BookShelf: Object{
    var shelf_id = 0
    var shelf_name = ""
    var shelf_owner = ""
    var created_at = NSDate()
    var is_private = false
    var shelf_books : [BookModel]?
}
