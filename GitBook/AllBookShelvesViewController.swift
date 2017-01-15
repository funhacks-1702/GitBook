//
//  AllBookShelvesViewController.swift
//  GitBook
//
//  Created by AtsuyaSato on 2017/01/15.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import UIKit

class AllBookShelvesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bookShelves: [BookShelfModel]? = []
    
    @IBOutlet weak var BookShelvdsTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        bookShelves = ShelfManager.sharedInstance.shelves
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        BookShelvdsTable.delegate = self
        BookShelvdsTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelves != nil ? (bookShelves?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .detailButton
        cell.textLabel?.text = "\(bookShelves?[indexPath.row].shelf_name)"
        cell.detailTextLabel?.text = "\(indexPath.row + 1)番目のセルの説明"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((bookShelves?[indexPath.row])!)
        tableView.deselectRow(at: indexPath, animated: true)
        // タップされたセルの情報を表示
        
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
