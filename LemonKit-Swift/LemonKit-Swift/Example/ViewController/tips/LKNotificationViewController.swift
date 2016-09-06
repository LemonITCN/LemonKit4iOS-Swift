//
//  LKNotificationViewController.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class LKNotificationViewController: UIViewController , LKNotificationDelegate {

    @IBAction func showBasicNotification(_ sender: UIButton) {
        self.getLKNotificationManager().default_style = LKNotificationStyle.DARK
        let notificationBar: LKNotificationBar = self.getLKNotificationManager().create(title: "这是一个LKNotification", content: "看这里，这是一个LK Notification Bar，在这里显示的是要提示的正文内容。", icon: UIImage(named: "icon")!)
        notificationBar.delegate = self
        notificationBar.show(animated: true)
//        self.setLKNotificationDefaultIcon(icon: UIImage(named: "icon")!)
//        self.showLKNotification(title: "这是一个LKNotification", content: "看这里，这是一个LK Notification Bar，在这里显示的是要提示的正文内容")
    }
    
    func onNavigationBarTouchUpInside(navigationBar: LKNotificationBar) {
        print("TOUCH !@")
    }

}
