//
//  LKActionItem.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/9/26.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

typealias LK_ACTION_SHEET_ON_ITEM_TOUCH = (LKActionItem) ->Void

private let DEFAULT_HEIGHT: CGFloat = 50.0

class LKActionItem: NSObject {
    
    /// 内容控件
    var contentView: UIView?
    /// 点击事件
    var action: LK_ACTION_SHEET_ON_ITEM_TOUCH?
    /// 控件的高度
    var height: CGFloat = DEFAULT_HEIGHT
    
    
    /// 通过标题，高度，默认的标题颜色初始化事件行
    ///
    /// - parameter title:     标题
    /// - parameter height:    事件行的高度
    /// - parameter textColor: 默认的事件行中的文本颜色
    ///
    /// - returns: 事件行的实例对象
    init(title: String , height: CGFloat , textColor: UIColor) {
        let titleView: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height))
        titleView.text = title
        titleView.textColor = textColor
        titleView.textAlignment = .center
        let line: UIView = UIView(frame: CGRect(x: 0, y: height, width: titleView.frame.size.width, height: 0.5))
        line.backgroundColor = UIColor(colorLiteralRed: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        titleView.addSubview(line)
        self.contentView = titleView
        self.height = height
    }
    
    /// 通过标题，高度，默认文字颜色，以及事件行的点击事件初始化事件行
    ///
    /// - parameter title:        标题
    /// - parameter height:       事件行的高度
    /// - parameter textColor:    默认的事件行中的文本颜色
    /// - parameter onTouchEvent: 事件行的触摸相应事件
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , height: CGFloat , textColor: UIColor , onTouchEvent: @escaping LK_ACTION_SHEET_ON_ITEM_TOUCH) {
        self.init(title: title , height: height , textColor: textColor)
        self.action = onTouchEvent
    }
    
    /// 通过标题，高度，默认的标题行颜色和selector初始化事件行
    ///
    /// - parameter title:        标题
    /// - parameter height:       事件行的高度
    /// - parameter textColor:    默认的事件行的文本高度
    /// - parameter onTouchEvent: 触摸事件的selector
    /// - parameter withObject:   selector作用于的对象
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , height: CGFloat , textColor: UIColor , onTouchEvent: Selector , withObject: NSObject){
        self.init(title: title , height: height , textColor: textColor)
        self.action = {item in
            withObject.perform(onTouchEvent)
        }
    }
    
    /// 通过标题，高度初始化事件行
    ///
    /// - parameter title:  标题
    /// - parameter height: 事件行的高度
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , height: CGFloat){
        self.init(title: title , height: height , textColor: UIColor.black)
    }
    
    /// 通过标题，默认的标题行文字颜色初始化事件行
    ///
    /// - parameter title:     标题
    /// - parameter textColor: 事件行的默认文字颜色
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , textColor: UIColor){
        self.init(title: title , height: DEFAULT_HEIGHT , textColor: textColor)
    }
    
    /// 通过标题初始化事件行
    ///
    /// - parameter title: 标题
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String){
        self.init(title: title , height: DEFAULT_HEIGHT , textColor: .black)
    }
    
    /// 通过标题，事件行的默认标题颜色和触摸事件来初始化事件行对象
    ///
    /// - parameter title:        标题
    /// - parameter textColor:    默认的事件行的文字颜色
    /// - parameter onTouchBlock: 触摸的回调函数
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , textColor: UIColor , onTouchBlock: @escaping LK_ACTION_SHEET_ON_ITEM_TOUCH){
        self.init(title: title  , height: DEFAULT_HEIGHT, textColor: textColor , onTouchEvent: onTouchBlock)
    }
    
    /// 通过标题，触摸时间来初始化事件行对象
    ///
    /// - parameter title:        标题
    /// - parameter onTouchBlock: 触摸的事件回调
    ///
    /// - returns: 事件行的实例对象
    convenience init(title: String , onTouchBlock: @escaping LK_ACTION_SHEET_ON_ITEM_TOUCH){
        self.init(title: title  , height: DEFAULT_HEIGHT, textColor: .black , onTouchEvent: onTouchBlock)
    }
    
    /// 通过自定义的控件和事件行的高度来初始化事件行对象
    ///
    /// - parameter customView: 自定义控件
    /// - parameter height:     事件行的高度
    ///
    /// - returns: 事件行的实例对象
    init(customView: UIView , height: CGFloat){
        self.contentView = customView
        self.height = height
    }
    
    /// 通过自定义的控件和行高以及点击回调来初始化事件行对象
    ///
    /// - parameter customView:   自定义的控件
    /// - parameter height:       默认的行高
    /// - parameter onTouchBlock: 触摸的回调block
    ///
    /// - returns: 事件行的实例对象
    init(customView: UIView , height: CGFloat , onTouchBlock: @escaping LK_ACTION_SHEET_ON_ITEM_TOUCH){
        self.contentView = customView
        self.height = height
        self.action = onTouchBlock
    }
    
}
