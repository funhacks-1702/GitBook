//
//  ShelfManager.swift
//  GitBook
//
//  Created by Yuta on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import RealmSwift
import UIKit

class ShelfManager {
    
    var shelves: [BookShelfModel]?
    let realm = try! Realm()
    
    static let Shelf = ShelfManager()
    init(){
        //BookShelfModel型のオブジェクトを全て読み出し
        //shelves = try? Array(realm.objects(BookShelfModel.self)).sorted(by: {   $0.shelf_id! < $1.shelf_id! })
        shelves = try! Array(realm.objects(BookShelfModel.self).sorted(byKeyPath: "shelf_id", ascending: true))
    }
    
    func commitData(){
        try! realm.write {
            for i in 0 ..< (shelves?.count)! {
                realm.add((shelves?[i])!, update: true)
            }
        }
    }
}
