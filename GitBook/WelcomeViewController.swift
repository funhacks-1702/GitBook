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
        GitHubConnection.sharedInstance.createNewProj(name: "test")
    }
/// ナビゲーションバー有効にする
//    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

