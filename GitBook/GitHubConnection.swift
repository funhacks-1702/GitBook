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

class GitHubConnection {
    var code: String!
    let clientId = "4afadd9b0d399d181f05"
    let clientSecret = "b1ea6a00f2bb9e4f3a0ff38d0a3aa476efa992ee"
    var accessToken: String!
    var user: GitHubUserModel!
    
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
            let url = URL(string:"https://github.com/login/oauth/authorize?client_id=\(clientId)")
            // Safari が開く場合
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            return
        }
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
            "Content-Type": "application/json"
        ]
        let params: Parameters = [
            "name" : name,
            "access_token" : accessToken
        ]
        
        Alamofire.request("https://api.github.com/user/repos",method: .post, parameters: params, headers: headers).responseJSON { response in
            if let json:[Any] = response.result.value as?[Any] {
                for repo in json {
                    let githubRepo:GitHubRepoModel? = Mapper<GitHubRepoModel>().map(JSONObject: repo)
                }
            }
        }

    }
}
