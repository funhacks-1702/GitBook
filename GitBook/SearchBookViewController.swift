//
//  SearchBookViewController.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import UIKit
import Kanna
import SDWebImage

class SearchBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var books: [BookModel]? = []
    
    @IBOutlet weak var bookSearchTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getBookInfoFromHTML(searchName: "Ruby")
        let nib = UINib(nibName: "BookListTableViewCell", bundle: nil)
        bookSearchTable.register(nib, forCellReuseIdentifier: "BookCell")
        bookSearchTable.delegate = self
        bookSearchTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books != nil ? (books?.count)! : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let cell: BookListTableViewCell = bookSearchTable.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookListTableViewCell
        cell.setCell(model: (books?[indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((books?[indexPath.row])!)
        bookSearchTable.deselectRow(at: indexPath, animated: true)
        // タップされたセルの情報を表示
    }
    
    func getBookInfoFromHTML (searchName: String) {
        let url: URL = URL(string: "https://www.amazon.co.jp/s/ref=nb_sb_noss_2?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias%3Dstripbooks&field-keywords=\(searchName)")!
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                let doc = HTML(html: data!, encoding: .utf8)

                for contentsList in doc!.css("div.s-item-container"){
                    var book_name:String? = ""
                    var book_url:String? = ""
                    var book_image_url:String? = ""
                    var author:String? = ""
                    
                    for bookName in contentsList.css("a.a-link-normal.s-access-detail-page.a-text-normal"){                        book_name = bookName["title"]!
                        book_url = bookName["href"]!
                    }
                    for bookImageURL in contentsList.css("img.s-access-image.cfMarker"){
                        book_image_url = bookImageURL["src"]
                    }
                    for bookAuthor in contentsList.css("div.a-row.a-spacing-mini div.a-row.a-spacing-none span.a-size-small.a-color-secondary a.a-link-normal.a-text-normal"){
                        if (bookAuthor.innerHTML != "詳細を見る") {
                            author = bookAuthor.innerHTML
                            break
                        }
                    }
                    
                    let book: BookModel? = BookModel(value: ["book_name":book_name,"book_url":book_url,"book_image_url":book_image_url,"author":author])

                    self.books?.append(book!)
                    self.bookSearchTable.reloadData()
                    
                }
            }
            
        })
        task.resume()
    }
}
