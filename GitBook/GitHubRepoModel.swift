//
//  GitRepo.swift
//  GitConnection
//
//  Created by AtsuyaSato on 2017/01/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import ObjectMapper
/// GitHubのユーザアカウント用モデルクラス
class GitHubRepoModel: Mappable {
    var name: String?
    var full_name : String?
    var html_url : String?
    var url : String?
    var git_url : String?
    var ssh_url : String?
    var clone_url : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        full_name <- map["full_name"]
        html_url <- map["html_url"]
        url <- map["url"]
        git_url <- map["git_url"]
        ssh_url <- map["ssh_url"]
        clone_url <- map["clone_url"]
    }
}
