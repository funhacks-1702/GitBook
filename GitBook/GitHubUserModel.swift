//
//  GitUser.swift
//  GitConnection
//
//  Created by AtsuyaSato on 2017/01/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import ObjectMapper
/// GitHubのユーザアカウント用モデルクラス
class GitHubUserModel: Mappable {
    var avatar_url: String?
    var login : String?
    var name : String?
    var repos_url : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        avatar_url <- map["avatar_url"]
        login <- map["login"]
        name <- map["name"]
    }
}
