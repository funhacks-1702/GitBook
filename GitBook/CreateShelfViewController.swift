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
                    // タイトル, メッセージ, Alertのスタイルを指定する
                    // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
                    let alert: UIAlertController = UIAlertController(title: "GitHubのアカウントを作成", message: "本棚の公開機能を利用するには、GitHubのアカウントが必要です。アカウントをお持ちでない場合はmいかの「アカウント登録」ボタンより、GitHubアカウントを作成してください。", preferredStyle:  UIAlertControllerStyle.alert)
                    
                    // ② Actionの設定
                    // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                    // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                    // OKボタン
                    let defaultAction: UIAlertAction = UIAlertAction(title: "アカウント作成", style: UIAlertActionStyle.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("OK")
                    })
                    // キャンセルボタン
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("Cancel")
                    })
                    
                    // ③ UIAlertControllerにActionを追加
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    
                    // ④ Alertを表示
                    present(alert, animated: true, completion: nil)
                }
            }
            
            let repo_name = "\(shelf_name)-GitBook"
            
            GitHubConnection.sharedInstance.createNewProj(name: shelf_name, callback: {
                GitHubConnection.sharedInstance.uploadsFile(file_name: "sample", type: "css", repo_name: repo_name)

            })
            
            let bookShelf = BookShelfModel()
            bookShelf.shelf_name = shelf_name
            bookShelf.repository = repo_name
            bookShelf.created_at = Date() as NSDate?
            ShelfManager.sharedInstance.shelves?.append(bookShelf)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AllBookShelvesViewController")
            self.navigationController?.pushViewController(controller, animated: true)

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
