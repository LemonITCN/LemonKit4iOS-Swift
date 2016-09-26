//
//  LKActionSheetView.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/9/26.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

private var _defaultActionSheetWindow: UIWindow?
private let LKScreen: CGSize = UIScreen.main.bounds.size
private let HEAD_VIEW_HEIGHT: CGFloat = 40.0
private let VIEW_MAX_HEIGHT_IN_SCREEN: CGFloat = 0.4

private var isShowing: Bool  = false
private var defaultActionSheetViewObj: LKActionSheetView?

/// ActionSheet选择器控件
class LKActionSheetView: NSObject {
    
    /// 事件组之间的缝隙的高度数值
    var groupHeightSpace: CGFloat?
    /// 事件组之间的缝隙的高度数值
    var headViewHeight: CGFloat?
    /// 头部标题控件
    var headView: UILabel?
    
    private var titleString: String?
    
    /// 顶部显示的标题
    var title: String {
        set(newValue){
            self.headView?.text = newValue
        }
        get{
            return (self.headView?.text)!
        }
    }
    
    private var _actionItems: Array<Array<LKActionItem>>?;
    private var _maskView: UIView?
    private var _contentView: UIView?
    private var _bodyView: UIScrollView?
    private var _mainWindow: UIWindow?
    
    override init() {
        super.init()
        if _defaultActionSheetWindow == nil{
            _defaultActionSheetWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: LKScreen.width, height: 0))
            _defaultActionSheetWindow?.clipsToBounds = true
        }
        self.clear()
        self.groupHeightSpace = 7
        self._maskView = UIView(frame: CGRect(x: 0, y: 0, width: LKScreen.width, height: LKScreen.height))
        self._maskView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.4)
        self._maskView?.alpha = 0
        self._maskView?.addGestureRecognizer(UITapGestureRecognizer(target:  self, action:  #selector(hide)))
        self._contentView = UIView()
        self._contentView?.backgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        self.headView = UILabel()
        self.headView?.layer.borderColor = UIColor(colorLiteralRed: 0.84, green: 0.84, blue: 0.84, alpha: 1).cgColor
        self.headView?.backgroundColor = UIColor(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.headView?.font = UIFont.systemFont(ofSize:  13)
        self.headView?.textAlignment = .center
        self.headView?.layer.borderWidth = 1
        self._bodyView = UIScrollView()
        
        _defaultActionSheetWindow?.addSubview(self._maskView!)
        _defaultActionSheetWindow?.addSubview(self._contentView!)
        
        self._contentView?.addSubview(self._bodyView!)
        self._contentView?.addSubview(self.headView!)
    }
    
    static func defaultActionSheetView() ->LKActionSheetView{
        if defaultActionSheetViewObj == nil {
            defaultActionSheetViewObj = LKActionSheetView()
        }
        return defaultActionSheetViewObj!
    }
    
    func show() -> Void{
        if !isShowing && (self._actionItems?.count)! > 0 {
            // 当前还没有显示出来
            isShowing = true
            _mainWindow = UIApplication.shared.keyWindow
            _defaultActionSheetWindow?.frame = CGRect(x: 0, y: 0, width: LKScreen.width, height: LKScreen.height)
            _contentView?.frame = CGRect(x: 0, y: LKScreen.height, width: LKScreen.width, height: self.calViewHeight())
            self.initHeadView()
            self.initBodyView()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { 
                UIApplication.shared.keyWindow?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                _defaultActionSheetWindow?.makeKeyAndVisible()
                self._maskView?.alpha = 1
                self._contentView?.frame = CGRect(x: 0, y: LKScreen.height - self.calViewHeight() - self.headViewHeight!, width: LKScreen.width, height: self.calViewHeight())
                }, completion: { (finished: Bool) in
                    
            })
        }
        
    }
    
    func hide() -> Void {
        if isShowing {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { 
                self._maskView?.alpha = 0
                self._mainWindow?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self._contentView?.frame = CGRect(x: 0, y: LKScreen.height, width: LKScreen.width, height: self.calViewHeight())
                }, completion: { (finished) in
                    _defaultActionSheetWindow?.frame = CGRect(x: 0, y: 0, width: LKScreen.width, height: 0)
                    isShowing = false
                    self._mainWindow?.makeKeyAndVisible()
            })
        }
    }
    
    func addActionGroup() -> Void {
        self._actionItems?.append(Array())
    }
    
    func removeActionGroupAtIndex(index: Int){
        if index >= 0 && index < (self._actionItems?.count)! {
            self._actionItems?.remove(at: index)
        }
    }
    
    func clear() -> Void {
        self._actionItems = Array()
        self._actionItems?.append(Array())
    }
    
    func addAction(action: LKActionItem , groupIndex: Int) -> Void {
        self._actionItems?[groupIndex].append(action)
    }
    
    func inseretAction(action: LKActionItem , groupIndex: Int , location: Int) -> Void {
        self._actionItems?[groupIndex].insert(action, at: location < (self._actionItems?[groupIndex].count)! ? location : (self._actionItems?[groupIndex].count)!)
    }
    
    func removeAction(atIndex: Int , location: Int) -> Void {
        if atIndex < (self._actionItems?.count)! && location < (self._actionItems?[atIndex].count)! {
            self._actionItems?[atIndex].remove(at: location)
        }
    }
    
    func calContentHeight() -> CGFloat{
        var height: CGFloat = self.groupHeightSpace! * CGFloat((self._actionItems?.count)! - 1)
        for group: Array<LKActionItem> in self._actionItems! {
            for item: LKActionItem in group {
                height += item.height
            }
        }
        return height
    }
    
    func calViewHeight() -> CGFloat {
        let contentHeight: CGFloat = self.calContentHeight()
        let maxHeight: CGFloat = VIEW_MAX_HEIGHT_IN_SCREEN * LKScreen.height;
        return contentHeight > maxHeight ? maxHeight : contentHeight
    }
    
    func initHeadView() -> Void {
        self.headView?.frame = CGRect(x: -1, y: -1, width: LKScreen.width + 2, height: self.headViewHeight!)
    }
    
    func initBodyView() -> Void {
        self._bodyView?.frame = CGRect(x: 0, y: (self.headView?.frame.size.height)!, width: LKScreen.width, height: self.calViewHeight())
        var pointer: CGFloat = self.calContentHeight()
        self._bodyView?.contentSize = CGSize(width: 0, height: pointer)
        for view: UIView in (self._bodyView?.subviews)! {
            view.removeFromSuperview()
        }
        for group: Array<LKActionItem> in self._actionItems! {
            for item: LKActionItem in group {
                pointer -= item.height
                let lineView: LKActionLineView = LKActionLineView(frame: CGRect(x: 0, y: pointer, width: LKScreen.width, height: item.height), actionItem: item)
                lineView.addSubview(item.contentView!)
                lineView.backgroundColor = UIColor(colorLiteralRed: 0.93, green: 0.93, blue: 0.93, alpha: 1)
                self._bodyView?.addSubview(lineView)
            }
            pointer -= self.groupHeightSpace!
        }
    }
    
}
