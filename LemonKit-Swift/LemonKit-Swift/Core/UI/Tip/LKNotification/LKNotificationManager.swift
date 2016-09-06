//
//  LKNotificationManager.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

private let defaultManagerObj: LKNotificationManager = LKNotificationManager()

/// LK通知管理器
class LKNotificationManager: NSObject {
    
    /// @brief 默认的通知栏主题
    var default_style: LKNotificationStyle
    /// @brief 默认的通知栏透明度
    var default_alpha: CGFloat
    /// @brief 默认的图标
    var default_icon: UIImage?
    
    /**
     单例方法，获取默认的通知管理器
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:11
     
     - returns: 默认的通知管理器对象
     */
    class func defaultManager() -> LKNotificationManager{
        return defaultManagerObj
    }
    
    override init() {
        self.default_style = LKNotificationStyle.LIGHT
        self.default_alpha = 0.95
        
        super.init()
    }
    
    /**
     创建一个通知栏
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:42
     
     - parameter title:   通知标题
     - parameter content: 通知内容
     - parameter icon:    通知图标
     
     - returns: 通知栏对象
     */
    func create(title: String ,content: String , icon: UIImage) -> LKNotificationBar {
        let notificationBar: LKNotificationBar = LKNotificationBar(title: title, content: content, icon: icon, style: self.default_style)
        notificationBar.setBarAlpha(alpha: self.default_alpha)
        return notificationBar
    }

    /**
     创建一个默认图标的通知栏
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:25
     
     - parameter title:   通知标题
     - parameter content: 通知内容
     
     - returns: 通知栏对象
     */
    func create(title: String , content: String) -> LKNotificationBar{
        let notificationBar: LKNotificationBar = LKNotificationBar(title: title, content: content, icon: self.default_icon!, style: self.default_style)
        notificationBar.setBarAlpha(alpha: self.default_alpha)
        return notificationBar
    }
    
}
