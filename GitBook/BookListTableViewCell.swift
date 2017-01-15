//
//  BookListTableViewCell.swift
//  GitBook
//
//  Created by 佐藤秀輔 on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import UIKit
import SDWebImage

class BookListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    func setCell(model: BookModel){
        bookImage.sd_setImage(with: NSURL(string: model.book_image_url!) as URL?)
        bookName.text = model.book_name
        if model.author != nil{
            bookAuthor.text = model.author
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
