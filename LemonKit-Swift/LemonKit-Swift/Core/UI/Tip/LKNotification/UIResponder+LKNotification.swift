//
//  UIResponder+LKNotification.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

// MARK: - LemonKit通知的快捷扩展
extension UIResponder{
    
    /**
     获取全局默认的LK通知中心管理器
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:44
     
     - returns: 默认的通知中心管理器对象
     */
    func getLKNotificationManager() -> LKNotificationManager {
        return LKNotificationManager.defaultManager()
    }
    
    /**
     展示一个通知
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:04
     
     - parameter title:         消息的标题
     - parameter content:       消息的内容
     - parameter icon:          消息的图标
     - parameter style:         通知栏的主题
     - parameter autoCloseTime: 自动关闭的时间
     - parameter delegate:      导航栏的代理
     */
    func showLKNotification(title: String , content: String , icon: UIImage , style: LKNotificationStyle , autoCloseTime: Double ,delegate: LKNotificationDelegate) -> Void {
        let notificationBar: LKNotificationBar = self.getLKNotificationManager().create(title: title, content: content, icon: icon)
        notificationBar.delegate = delegate
        notificationBar.autoCloseTime = autoCloseTime
        notificationBar.show(animated: true)
    }
    
    /**
     展示一个通知
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:41
     
     - parameter title:   消息的标题
     - parameter content: 消息的内容
     - parameter icon:    消息的图标
     */
    func showLKNotification(title:String , content: String , icon: UIImage) -> Void {
        let notificationBar = self.getLKNotificationManager().create(title: title, content: content, icon: icon)
        notificationBar.show(animated: true)
    }
    
    /**
     展示一个通知
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:25
     
     - parameter title:   消息的标题
     - parameter content: 消息的内容
     */
    func showLKNotification(title: String , content: String) -> Void {
        let notificationBar = self.getLKNotificationManager().create(title: title, content: content)
        notificationBar.show(animated: true)
    }
    
    /**
     设置全局LK通知栏的默认图标
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:07
     
     - parameter icon: 默认的图标对象
     */
    func setLKNotificationDefaultIcon(icon: UIImage) -> Void {
        self.getLKNotificationManager().default_icon = icon
    }
    
    /**
     设置全局LK通知栏的默认主题
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:57
     
     - parameter style: 主题风格
     */
    func setLKNotificationDefaultStyle(style: LKNotificationStyle) -> Void{
        self.getLKNotificationManager().default_style = style
    }
    
    /**
     设置全局LK通知栏的默认透明度
     
     - author 1em0nsOft LiuRi
     - date 2016-08-30 11:08:29
     
     - parameter alpha 透明度数值
     */
    func setLKNotificationDefaultAlpha(alpha: CGFloat) -> Void {
        self.getLKNotificationManager().default_alpha = alpha
    }
    
}
