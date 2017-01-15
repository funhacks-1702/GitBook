//
//  WelcomeViewController.swift
//  GitBook
//
//  Created by AtsuyaSato on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //GitHubConnection.sharedInstance.createNewProj(name: "test2")
        ////アクセストークン確認(トークンがなければ取得)
        GitHubConnection.sharedInstance.confirmAccessToken()        
        GitHubConnection.sharedInstance.uploadsFile(file_name: "sample", type: "css", repo_name: "test2-GitBook")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

