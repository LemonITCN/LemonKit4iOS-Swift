//
//  LKNotificationBar.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 16/9/5.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

/// @brief 通知栏的主题枚举
enum LKNotificationStyle{
    /// @brief 亮主题
    case LIGHT
    /// @brief 暗主题
    case DARK
}

protocol LKNotificationDelegate  {
    
    /**
     导航栏被触摸相应事件
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 20:09:38
     
     - parameter navigationBar: 当前导航栏对象
     */
    func onNavigationBarTouchUpInside(navigationBar: LKNotificationBar) ->Void
}

private var navigationWindow: UIWindow?
private var _defaultWindow: UIWindow?// 默认的Window对象
private var navigationHeightDic: Dictionary<String , CGFloat> = Dictionary()

/// 通知控件，通常该View不需要手动实例化
class LKNotificationBar: UIControl {
    
    let padding = 10
    
    /// @brief 当前的通知栏是否处于显示状态
    var isShowing: Bool
    /// @brief 代理函数
    var delegate: LKNotificationDelegate?
    /// @brief 通知栏的标题
    var title: String {
        set{
            titleLabel.text = title
        }
        get{
            return titleLabel.text!
        }
    }
    /// @brief 通知栏的内容
    var content: String {
        set{
            contentLabel.text = content
            contentLabel.sizeToFit()
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 15) // 根据内容大小计算整体通知栏高度
            self.bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        }
        get{
            return contentLabel.text!
        }
    }
    /// @brief 通知栏的图标
    var icon: UIImage {
        set{
            iconImageView.image = icon
        }
        get{
            return iconImageView.image!
        }
    }
    /// @brief 自动关闭的时间
    var autoCloseTime: Double
    
    private var containerEffectView: UIVisualEffectView // 模糊背景
    private var iconImageView: UIImageView // 图标
    private var titleLabel: UILabel // 标题
    private var contentLabel: UILabel // 内容
    private var id: String // 通知栏的ID，用于存取通知栏的高度
    private var bottomLine: UIView// 底部的边框线控件
    
    /**
     通过传入通知栏的基本信息来构建一个通知栏
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 20:09:58
     
     - parameter title:   通知栏的标题
     - parameter content: 通知栏的内容
     - parameter icon:    通知栏的图标
     - parameter style:   通知栏的主题，分为亮、暗两种
     
     - returns: 通知栏的实例对象
     */
    init (title: String , content: String , icon: UIImage , style: LKNotificationStyle) {
        // 实例化公有变量
        self.isShowing = false
        self.autoCloseTime = 3.0
        
        if _defaultWindow == nil {
            _defaultWindow = UIApplication.shared.keyWindow// 保存默认的UIWindow
        }
        
        // 实例化私有变量
        let blurEffect : UIBlurEffect = UIBlurEffect.init(style: style == LKNotificationStyle.DARK ? UIBlurEffectStyle.dark : UIBlurEffectStyle.light)
        self.containerEffectView = UIVisualEffectView(effect: blurEffect)
        self.iconImageView = UIImageView()
        self.titleLabel = UILabel()
        self.contentLabel = UILabel()
        self.id = String.init(format: "%u", arc4random())
        self.bottomLine = UIView()
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
    
        let textColor: UIColor = style == LKNotificationStyle.LIGHT ? UIColor.black : UIColor.white
        self.iconImageView.frame = CGRect(x: padding, y: padding, width: 50, height: 50)
        self.iconImageView.layer.cornerRadius = 8
        self.iconImageView.clipsToBounds = true
        self.iconImageView.image = icon
        
        let titleX: CGFloat = self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10
        self.titleLabel.frame = CGRect(x: titleX, y: CGFloat(self.iconImageView.frame.origin.y), width: CGFloat(self.frame.size.width) - titleX - CGFloat(padding), height: 14.0)
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = textColor
        self.titleLabel.text = title
        
        let contentY: CGFloat = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 12;
        self.contentLabel.frame = CGRect(x: titleX, y: contentY, width: self.titleLabel.frame.size.width, height: 0)
        self.contentLabel.textColor = textColor
        self.contentLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentLabel.lineBreakMode = .byCharWrapping
        self.contentLabel.numberOfLines = 0
        self.contentLabel.textColor = textColor
        self.contentLabel.text = content
        
        self.bottomLine.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
        self.bottomLine.backgroundColor = UIColor.init(colorLiteralRed: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 0.3)
        self.addSubview(self.containerEffectView)
        self.addSubview(self.iconImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.bottomLine)
        
        if navigationWindow == nil {
            navigationWindow = UIWindow()
            navigationWindow?.windowLevel = UIWindowLevelStatusBar// 覆盖状态栏
            navigationWindow?.backgroundColor = UIColor.clear
            navigationWindow?.makeKeyAndVisible()
            navigationWindow?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: 0)// // 覆盖状态栏初始无大小
            navigationWindow?.isUserInteractionEnabled = true
            navigationHeightDic = Dictionary()
        }
        
        self.content = content
        self.title = title
        self.icon = icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAction() -> Void {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTap)))
    }
    
    func selfTap() -> Void {
        self.delegate?.onNavigationBarTouchUpInside(navigationBar: self)// 调用代理函数
        self.hide(animated: true)
    }
    
    /**
     设置导航栏的模糊透明度
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 20:09:33
     
     - parameter alpha: 透明度数值
     */
    func setBarAlpha(alpha: CGFloat) -> Void {
        self.containerEffectView.alpha = alpha
    }
    
    /**
     显示通知栏
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 20:09:18
     
     - parameter animated: 是否动画显示
     */
    func show(animated: Bool) -> Void {
        if !self.isShowing {
            navigationWindow?.makeKeyAndVisible()
        }
        self.isShowing = true
        navigationWindow?.frame = self.bounds
        navigationHeightDic[self.id] = self.frame.size.height
        navigationWindow?.addSubview(self)
        self.containerEffectView.frame = self.bounds
        self.frame = CGRect(x: 0, y: -1 * self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }) { (finished) in
                navigationWindow?.frame = self.bounds
                self.perform(#selector(self._hide), with: self, afterDelay: self.autoCloseTime)
        }
    }
    
    /**
     定时器触发
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 20:09:10
     */
    @objc private func _hide() -> Void {
        self.hide(animated: true)
    }
    
    /**
     隐藏通知栏
     
     - author: 1em0nsOft LiuRi
     - date: 2016-09-05 19:09:57
     
     - parameter animated: 是否动画隐藏
     */
    func hide(animated: Bool) -> Void {
        navigationHeightDic.removeValue(forKey: self.id)
        if navigationHeightDic.count == 0 {
            navigationWindow?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        }
        else{
            navigationWindow?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: navigationHeightDic.values.min()!)
        }
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: { 
            self.frame = CGRect(x: 0,y: -1 * self.frame.size.height,width: self.frame.size.width,height: self.frame.size.height)
            }) { (finished) in
                self.isShowing = false
                self.removeFromSuperview()
                if !self.isShowing {
                    _defaultWindow?.makeKeyAndVisible()// 重新恢复默认的UIWindow为keyWindow
                }
        }
    }
    
}
