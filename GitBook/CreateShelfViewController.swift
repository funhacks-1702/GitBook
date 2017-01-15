//
//  CreateShelfViewController.swift
//  GitBook
//
//  Created by AtsuyaSato on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import UIKit

class CreateShelfViewController: UIViewController,UITextFieldDelegate {
    /// ナビゲーションバー有効にする
    @IBOutlet weak var check_btn: UIButton!
    var publish_flg = false
    var shelf_name:String = ""
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var connectGitHub: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        connectGitHub.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkBtnClicked(_ sender: Any) {
        publish_flg = !publish_flg
        if(publish_flg){
            connectGitHub.isHidden = false
self.check_btn.setImage(UIImage(named:"btn_post_photo_check_on"), for: .normal)
        }else{
            connectGitHub.isHidden = true
self.check_btn.setImage(UIImage(named:"btn_post_photo_check_off"), for: .normal)
        }
        if let user = GitHubConnection.sharedInstance.user {
            if let accessToken = GitHubConnection.sharedInstance.accessToken {
                connectGitHub.isHidden = true
            }
        }
    }
    
    @IBAction func textEditing(_ sender: Any) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    @IBAction func connectGitHub(_ sender: Any) {
        GitHubConnection.sharedInstance.confirmAccessToken()
        //アクセストークン確認(トークンがなければ取得)
        connectGitHub.isHidden = true

    }
    @IBAction func addBookShelf(_ sender: Any) {
        if(publish_flg){
            if let user = GitHubConnection.sharedInstance.user {
                if let accessToken = GitHubConnection.sharedInstance.accessToken {
                    
                    
                    let repo_name = "\(textField.text!)-GitBook"
                    
                    GitHubConnection.sharedInstance.createNewProj(name: textField.text!, callback: {
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "books-templete", type: "html", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "bookshelves-templete", type: "html", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "index", type: "html", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "jquery-loadTemplete", type: ".min.js", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "main", type: "css", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "main", type: "js", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "shelves", type: "json", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "sidebar-templete", type: "html", repo_name: repo_name)
                        GitHubConnection.sharedInstance.uploadsFile(file_name: "tags-templete", type: "html", repo_name: repo_name)
    //                    GitHubConnection.sharedInstance.uploadsFile(file_name: "mokume3-mini", type: "jpg", repo_name: repo_name)
//                        
                    })
                    
                    let bookShelf = BookShelfModel()
                    bookShelf.shelf_name = self.shelf_name
                    bookShelf.repository = repo_name
                    bookShelf.created_at = Date() as NSDate?
                    ShelfManager.sharedInstance.shelves?.append(bookShelf)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "AllBookShelvesViewController")
                    self.navigationController?.pushViewController(controller, animated: true)

                }
            }else{
                
            }
        }else{
            let bookShelf = BookShelfModel()
            bookShelf.shelf_name = shelf_name
            bookShelf.created_at = Date() as NSDate?
            ShelfManager.sharedInstance.shelves?.append(bookShelf)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AllBookShelvesViewController")
            self.navigationController?.pushViewController(controller, animated: true)

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
