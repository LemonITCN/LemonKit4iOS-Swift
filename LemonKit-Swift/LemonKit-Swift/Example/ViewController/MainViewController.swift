//
//  MainViewController.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    private var titleArray: Array<String>?
    private var segueIdentifierArray: Array<String>?
    private let identifier: String  = "MAIN_CELL_IDENTIFIER"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleArray = ["Custom Views" , "Tips"]
        self.segueIdentifierArray = ["ShowCustomViewsViewController" , "ShowTipsViewController"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.titleArray?.count)!
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
        self.performSegue(withIdentifier: (self.segueIdentifierArray?[indexPath.row])!, sender: self)
    }

}
