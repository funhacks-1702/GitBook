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

class SearchBookViewController: UIViewController{
    
    var books: [BookModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getBookInfoFromHTML(searchName: "Ruby")
        let nib = UINib(nibName: "BookListTableViewCell", bundle: nil)
//        てーぶるびゅー.register(nib, forCellReuseIdentifier: "BookCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    var author:[String]? = []
                    
                    for bookName in contentsList.css("a.a-link-normal.s-access-detail-page.a-text-normal"){                        book_name = bookName["title"]!
                        book_url = bookName["href"]!
                    }
                    for bookImageURL in contentsList.css("img.s-access-image.cfMarker"){
                        book_image_url = bookImageURL["src"]
                    }
                    for bookAuthor in contentsList.css("div.a-row.a-spacing-mini div.a-row.a-spacing-none span.a-size-small.a-color-secondary a.a-link-normal.a-text-normal"){
                        author?.append(bookAuthor.innerHTML!)
                    }
                    for i in 0 ..< author!.count{
                        if (author?[i] == "詳細を見る") {
                            author?.remove(at: i)
                            break
                        }
                    }
                    let book: BookModel? = BookModel(value: ["book_name":book_name,"book_url":book_url,"book_image_url":book_image_url,"authors":author])

                    self.books?.append(book!)
                }
            }
            
        })
        task.resume()
    }
}
