//
//  ShelfManager.swift
//  GitBook
//
//  Created by Yuta on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import ObjectMapper
import UIKit

class ShelfManager {
    
    var shelves: [BookShelfModel]?
    
    static let sharedInstance = ShelfManager()
    init(){
        //BookShelfModel型のオブジェクトを全て読み出し
    }
    
}
