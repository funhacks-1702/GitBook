//
//  MyGitHubLogin.swift
//  GitConnection
//
//  Created by AtsuyaSato on 2017/01/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
// リポジトリ作成
// GitHubConnection.sharedInstance.createNewProj(name: "test")


class GitHubConnection {
    var code: String!
    let clientId = "4afadd9b0d399d181f05"
    let clientSecret = "b1ea6a00f2bb9e4f3a0ff38d0a3aa476efa992ee"
    var accessToken: String!
    var user: GitHubUserModel!
    var repos: [GitHubRepoModel]?
    
    static let sharedInstance = GitHubConnection()
    init() {
        
    }
    //AccessTokenが存在しなければOAuth認証によってAccessToken取得
    func confirmAccessToken(){
        let userDefault = UserDefaults.standard
        self.accessToken = userDefault.object(forKey: "access_token") as! String!
        //AccessTokenが存在しない時
        guard let accessToken = self.accessToken else{
            let clientId = self.clientId
            let url = URL(string:"https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=repo")
            // Safari が開く場合
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            return
        }
        print("accessToken",accessToken)
        getUserData()
    }
    /// ユーザデータ取得
    func getUserData(){
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let params: Parameters = [
            "access_token" : self.accessToken!
        ]
        Alamofire.request("https://api.github.com/user",method: .get, parameters: params, headers: headers).responseJSON { response in
            /*
             print(response.request)  // original URL request
             print(response.response) // HTTP URL response
             print(response.data)     // server data
             print(response.result)   // result of response serialization
             */
            if let json = response.result.value {
                //print("json: \(json)")
                let user:GitHubUserModel? = Mapper<GitHubUserModel>().map(JSONObject: json)
                self.user = user
            }
        }
    }
    /// アクセストークン取得
    /// - parameter code: OAuthの返却値
    func getAccessToken(code: String!) {
        self.code = code
        print("code:",code)

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let params: Parameters = [
            "client_id" : self.clientId,
            "client_secret" : self.clientSecret,
            "code" : self.code!,
        ]
        Alamofire.request("https://github.com/login/oauth/access_token",method: .post, parameters: params, headers: headers).responseJSON { response in
            /*
             メモ
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            */
            if let json:[String:Any] = response.result.value as? [String:Any]{
                print("JSON: \(json)")
                self.accessToken = json["access_token"] as! String!
                let userDefault = UserDefaults.standard
                userDefault.set(self.accessToken, forKey: "access_token")

                self.getUserData()
            }
        }
    }
    /// レポジトリ一覧取得
    func getReposList(){
        guard let accessToken = self.accessToken else{
            return
        }
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let params: Parameters = [
            "access_token" : accessToken
        ]
        
        Alamofire.request("https://api.github.com/user/repos",method: .get, parameters: params, headers: headers).responseJSON { response in
            if let json:[Any] = response.result.value as?[Any] {
                for repo in json {
                    let githubRepo:GitHubRepoModel? = Mapper<GitHubRepoModel>().map(JSONObject: repo)
                    print(githubRepo?.name)
                }
            }
        }
        
    }
    //リポジトリ作成
    func createNewProj(name:String)
    {
        guard let accessToken = self.accessToken else{
            return
        }
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "token \(self.accessToken!)"
        ]
        let params: Parameters = [
            "name" : "\(name)-GitBook",
            "description": "This is your first repository",
            "has_pages":true,
            "auto_init":true
        ]
        Alamofire.request("https://api.github.com/user/repos", method: .post, parameters: params, encoding:JSONEncoding.default , headers: headers).responseJSON{ response in
            print(response.result.value)
            let githubRepo:GitHubRepoModel? = Mapper<GitHubRepoModel>().map(JSONObject: response.result.value)
            self.repos?.append(githubRepo!)
        }
    }
    func uploadsFile(file_name:String,type:String,repo_name:String){
        guard let accessToken = self.accessToken else{
            return
        }
        guard let user = self.user else{
            return
        }
        
        guard let bundle = Bundle.main.path(forResource: file_name, ofType: type) else {
            return
        }
        
        let content = try! String(contentsOfFile: bundle, encoding: String.Encoding.utf8)
        let base64Encoded = Data(content.utf8).base64EncodedString()

        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "token \(accessToken)"
        ]
        let params: Parameters = [
            "message" : "[update] \(file_name).\(type)",
            "content": base64Encoded
        ]
        
        
        Alamofire.request("https://api.github.com/repos/\(user.login!)/\(repo_name)/contents/\(file_name).\(type)", method: .put, parameters: params, encoding:JSONEncoding.default , headers: headers).responseJSON{ response in
            print(response.result.value)
//            let githubRepo:GitHubRepoModel? = Mapper<GitHubRepoModel>().map(JSONObject: response.result.value)
//            self.repos?.append(githubRepo!)
        }

    }
}
