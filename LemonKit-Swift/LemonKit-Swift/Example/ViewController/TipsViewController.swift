//
//  TipsViewController.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class TipsViewController: UITableViewController {
    
    private var titleArray: Array<String>?
    private var viewControllerIDArray: Array<String>?
    private var tipStoryBoard: UIStoryboard?
    
    private let identifier: String = "TIPS_CELL"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleArray = ["LKNotification" , "LKActionSheet"]
        self.viewControllerIDArray = ["LKNotificationViewController" , "LKActionSheetViewController"]
        self.tipStoryBoard = UIStoryboard.init(name: "Tips", bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewControllerIDArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = self.titleArray?[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController((self.tipStoryBoard?.instantiateViewController(withIdentifier: (viewControllerIDArray?[indexPath.row])!))!, animated: true)
    }

}
