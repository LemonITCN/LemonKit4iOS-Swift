//
//  LKBubbleView.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/10/19.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

private var defaultBubbleViewObj: LKBubbleView = LKBubbleView()

/// LK泡泡控件
class LKBubbleView: UIView {
    
    /// 进度属性
    private var _progress: CGFloat?
    /// 泡泡控件中的图标控件
    private var _iconImageView: UIImageView = UIImageView()
    /// 泡泡控件中的标题控件
    private var _titleLabel: UILabel = UILabel()
    /// 是否正在显示中
    private var _isShowing: Bool?
    /// 存储泡泡信息对象的字典
    private var _infoDic: Dictionary<String , LKBubbleInfo> = NSDictionary() as! Dictionary<String, LKBubbleInfo>
    /// 当前正在显示的泡泡信息对象
    private var _currentInfo: LKBubbleInfo?
    /// 当前自定义动画绘图的图层
    private var _currentDrawLayer: CAShapeLayer?
    /// 当前使用的图片帧动画计时器
    private var _currentTimer: Timer?
    /// 蒙版view
    private var _maskView: UIView = UIView(frame: UIScreen.main.bounds)
    /// 关闭验证key，用来做关闭时候的延迟验证，当设置自动关闭之后，若在关闭之前出发了显示其他info的bubble，通过修改这个值保证不关闭其他样式的infoBubble
    private var _closeKey: CGFloat?
    /// 帧动画播放的下标索引
    private var _frameAnimationPlayIndex: Int?
    
    /// 单例方法
    ///
    /// - returns: 获取泡泡控件的实例对象
    static func defaultBubbleView() -> LKBubbleView {
        return defaultBubbleViewObj
    }
    
    init() {
        let keyWindow: UIWindow = UIApplication.shared.keyWindow!
        super.init(frame: CGRect(x: keyWindow.center.x, y: keyWindow.center.y, width: 0, height: 0))
        self.clipsToBounds = true
        self._iconImageView.clipsToBounds = true
        self._titleLabel.textAlignment = .center
        self._titleLabel.lineBreakMode = .byCharWrapping
        self._titleLabel.numberOfLines = 0
        self._maskView.isHidden = true
        
        self.addSubview(self._iconImageView)
        self.addSubview(self._titleLabel)
    }
    
    /// 注册泡泡信息对象
    ///
    /// - parameter info: 泡泡信息对象
    /// - parameter key:  泡泡信息对象对应的键
    func registerInfo(info: LKBubbleInfo , key: String) -> Void {
        self._infoDic[key] = info
    }
    
    /// 显示指定的信息模型对应的泡泡控件
    ///
    /// - parameter info: 泡泡控件的信息对象
    func showWithInfo(info: LKBubbleInfo) -> Void {
        self._currentInfo = info
        self._closeKey = self._currentInfo?.key// 保存当前要关闭的key，防止关闭不需要关闭的bubble
        if info.isShowMaskView {
            UIApplication.shared.keyWindow?.addSubview(self._maskView)
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { 
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
            if self._currentDrawLayer != nil{
                self._currentDrawLayer?.removeFromSuperlayer()
            }
            self.frame = info.calBubbleViewFrame()
            self._iconImageView.frame = info.calIconViewFrame()
            self._titleLabel.frame = info.calTitleViewFrame()
            self._titleLabel.text = info.title
            self._titleLabel.font = UIFont.systemFont(ofSize:  info.titleFontSize)
            self.layer.cornerRadius = info.cornerRadius
            
            if info.iconArray == nil || info.iconArray?.count == 0 {
                // 显示自定义动画
                self._iconImageView.image = UIImage()
                self._currentDrawLayer = CAShapeLayer()
                self._currentDrawLayer?.fillColor = UIColor.clear.cgColor
                self._currentDrawLayer?.frame = self._iconImageView.bounds
                self._iconImageView.layer.addSublayer(self._currentDrawLayer!)
                self._currentTimer?.invalidate()
                DispatchQueue.main.async {
                    if info.iconAnimation != nil {
                        info.iconAnimation!(self._currentDrawLayer!)
                    }
                }
            }
            else if info.iconArray?.count == 1 {
                // 显示单张图片
                self._currentTimer?.invalidate()
                self._iconImageView.image = info.iconArray?[0]
            }
            else {
                // 逐帧连环动画
                self._frameAnimationPlayIndex = 0
                self._iconImageView.image = self._currentInfo?.iconArray?[0]
                self._currentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(info.frameAnimationTime), target: self, selector: #selector(self.frameAnimationPlayer), userInfo: nil, repeats: true)
            }
            // maskView
            if (self._currentInfo?.isShowMaskView)! && self._maskView.isHidden {
                // 本次需要显示，但是之前已经隐藏
                self._maskView.alpha = 0
                self._maskView.isHidden = false
            }
            self._maskView.alpha = (self._currentInfo?.isShowMaskView)! ? 1 : 0
            
        }) { (b: Bool) in
            if !(self._currentInfo?.isShowMaskView)! {
                self._maskView.isHidden = true
                self._maskView.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCurlUp, animations: { 
            self._titleLabel.textColor = info.titleColor
            self.backgroundColor = info.backgroundColor
            self._currentDrawLayer?.strokeColor = info.iconColor.cgColor
            self._maskView.backgroundColor = self._currentInfo?.maskColor
        }) { (finished: Bool) in
            
        }
        
    }
    
    /// 帧动画播放器 - Timer调用
    @objc private func frameAnimationPlayer() -> Void {
        self._iconImageView.image = self._currentInfo?.iconArray?[self._frameAnimationPlayIndex!]
        self._frameAnimationPlayIndex = (self._frameAnimationPlayIndex! + 1) % (self._currentInfo?.iconArray?.count)!
    }
    
    /// 通过传入键来显示已经注册的指定样式泡泡控件
    ///
    /// - parameter infoKey: 泡泡控件的样式键
    func showWithInfoKey(infoKey: String) -> Void {
        if self._infoDic.keys.contains(infoKey) {
            self.showWithInfo(info:  self._infoDic[infoKey]!)
        }
    }
    
    /// 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
    ///
    /// - parameter info:          样式信息模型
    /// - parameter autoCloseTime: 指定时间后隐藏泡泡控件的秒数
    func showWithinfo(info: LKBubbleInfo , autoCloseTime: CGFloat) -> Void {
        self.showWithInfo(info:  info)
        self.perform(#selector(hide), with: self, afterDelay: TimeInterval(autoCloseTime + 0.2))
    }
    
    /// 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
    ///
    /// - parameter infoKey:       已注册的样式信息模型的键
    /// - parameter autoCloseTime: 指定时间后隐藏泡泡控件的秒数
    func showWithInfoKey(infoKey: String , autoCloseTime: CGFloat) -> Void {
        if self._infoDic.keys.contains(infoKey) {
            self.showWithinfo(info: self._infoDic[infoKey]!, autoCloseTime: autoCloseTime)
        }
    }
    
    /// 隐藏当前泡泡控件
    func hide() -> Void {
        if self._closeKey == self._currentInfo?.key {
            // 要关闭的key没有变化，可以关闭
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { 
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self._maskView.alpha = 0
                self.alpha = 0
                }, completion: { (finished: Bool) in
                    self.removeFromSuperview()
                    self._maskView.removeFromSuperview()
            })
        }
    }
    
    
    /// 设置进度
    ///
    /// - parameter progress: 进度数值
    func setProgress(progress: CGFloat) -> Void {
        self._progress = progress
        if self._currentInfo?.onProgressChanged != nil {
            DispatchQueue.main.async {
                self._currentInfo?.onProgressChanged!(self._currentDrawLayer!, progress)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
