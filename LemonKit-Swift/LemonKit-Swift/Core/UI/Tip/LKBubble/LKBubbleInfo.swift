//
//  LKBubbleInfo.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/10/19.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit


/// 通知栏的主题枚举
///
/// - BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM: 图上文下
/// - BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP: 图下文上
/// - BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT: 图左文右
/// - BUBBLE_LAYOUT_STYLE_ICON_RIGHT_TITLE_LEFT: 图右文左
/// - BUBBLE_LAYOUT_STYLE_ICON_ONLY:             只显示图
/// - BUBBLE_LAYOUT_STYLE_TITLE_ONLY:            只显示文
enum LKBubbleLayoutStyle{
    /// 图上文下
    case BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM
    /// 图下文上
    case BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP
    /// 图左文右
    case BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT
    /// 图右文左
    case BUBBLE_LAYOUT_STYLE_ICON_RIGHT_TITLE_LEFT
    /// 只显示图
    case BUBBLE_LAYOUT_STYLE_ICON_ONLY
    /// 只显示文
    case BUBBLE_LAYOUT_STYLE_TITLE_ONLY
}


/// 泡泡控件位置枚举
///
/// - BUBBLE_LOCATION_STYLE_TOP:    位于屏幕底部
/// - BUBBLE_LOCATION_STYLE_CENTER: 位于屏幕中间
/// - BUBBLE_LOCATION_STYLE_BOTTOM: 位于屏幕底部
enum LKBubbleLocationStyle{
    /// 位于屏幕底部
    case BUBBLE_LOCATION_STYLE_TOP
    /// 位于屏幕中间
    case BUBBLE_LOCATION_STYLE_CENTER
    /// 位于屏幕底部
    case BUBBLE_LOCATION_STYLE_BOTTOM
}

/// 自定义动画typealias
typealias LKBubbleCustomAnimation = (_ layer: CAShapeLayer) -> Void

/// 自定义进度样式typealias
typealias LKBubbleOnProgressChanged = (_ layer: CAShapeLayer ,_ progress: CGFloat) -> Void

class LKBubbleInfo: NSObject {
    
    
    /// 泡泡控件的大小
    var bubbleSize: CGSize = CGSize(width: 180, height: 120)
    /// 泡泡控件的圆角半径
    var cornerRadius: CGFloat = 8
    /// 图文布局属性
    var layoutStyle: LKBubbleLayoutStyle = LKBubbleLayoutStyle.BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM
    /// 图标动画
    var iconAnimation: LKBubbleCustomAnimation?
    /// 进度被改变的回调block
    var onProgressChanged: LKBubbleOnProgressChanged?
    /// 图标数组，如果该数组为空或者该对象为nil，那么显示自定义动画，如果图标为一张，那么固定显示那个图标，大于一张的时候显示图片帧动画
    var iconArray: Array<UIImage>?
    /// 要显示的标题
    var title: String = "LKBubble"
    /// 帧动画时间间隔
    var frameAnimationTime: CGFloat = 0.1
    /// 图标占比 0 - 1，图标控件的边长占高度的比例
    var proportionOfIcon: CGFloat = 0.675
    /// 间距占比 0 - 1，图标控件和标题控件之间距离占整个控件的比例（如果横向布局那么就相当于宽度，纵向布局相当于高度）
    var proportionOfSpace: CGFloat = 0.1
    /// 内边距占比 0 - 1，整个泡泡控件的内边距，x最终为左右的内边距，y最终为上下的内边距（左右内边距以宽度算最终的像素值，上下边距以高度算最终的像素值）
    var proportionOfPadding: CGPoint = CGPoint(x: 0.1, y: 0.1)
    /// 位置样式
    var locationStyle: LKBubbleLocationStyle = LKBubbleLocationStyle.BUBBLE_LOCATION_STYLE_CENTER
    /// 泡泡控件显示时偏移，当位置样式为上中的时候，偏移值是向下移动，当位置样式为底部时候，偏移值是向上移动
    var proportionOfDeviation: CGFloat = 0
    /// 是否展示蒙版，展示蒙版后，显示泡泡控件时会产生一个蒙版层来拦截所有其他控件的点击事件
    var isShowMaskView: Bool = true
    /// 蒙版颜色
    var maskColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
    /// 背景色
    var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    /// 图标渲染色
    var iconColor: UIColor = .white
    /// 标题文字颜色
    var titleColor: UIColor = .white
    /// 标题字体大小
    var titleFontSize: CGFloat = 13
    /// key，随机数，用于标志一个info的唯一性，关闭时候会通过这个验证
    var key: CGFloat = CGFloat(arc4random())
    
    override init() {
        super.init()
    }
    
    /// 通过标题和图标来初始化泡泡控件信息对象
    ///
    /// - parameter title: 泡泡控件要显示的标题
    /// - parameter icon:  泡泡控件要显示的图标
    ///
    /// - returns: 泡泡控件的信息对象
    init(title: String , icon: UIImage) {
        self.title = title
        self.iconArray = [icon]
    }
    
    /// 计算泡泡控件的frame
    ///
    /// - returns: 泡泡控件整体的frame
    func calBubbleViewFrame() -> CGRect {
        var y: CGFloat
        switch self.locationStyle {
        case .BUBBLE_LOCATION_STYLE_TOP:
            y = 0
        case .BUBBLE_LOCATION_STYLE_CENTER:
            y = (UIScreen.main.bounds.size.height - self.bubbleSize.height) / 2
        case .BUBBLE_LOCATION_STYLE_BOTTOM:
            y = UIScreen.main.bounds.size.height - self.bubbleSize.height
        }
        y += (self.locationStyle != .BUBBLE_LOCATION_STYLE_BOTTOM ? 1 : -1) * (self.proportionOfDeviation * UIScreen.main.bounds.size.height);
        return CGRect(x: (UIScreen.main.bounds.size.width - self.bubbleSize.width) / 2, y: y, width: self.bubbleSize.width, height: self.bubbleSize.height)
    }
    
    
    /// 计算泡泡控件中的图标的frame
    ///
    /// - returns: 图标控件的farme
    func calIconViewFrame() -> CGRect {
        let bubbleContentSize: CGSize = CGSize(width: self.bubbleSize.width * (1 - self.proportionOfPadding.x * 2), height: self.bubbleSize.height * (1 - self.proportionOfPadding.y * 2))
        let baseX: CGFloat = self.bubbleSize.width * self.proportionOfPadding.x
        let baseY: CGFloat = self.bubbleSize.height * self.proportionOfPadding.y
        let iconWidth: CGFloat = self.layoutStyle == .BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM || self.layoutStyle == .BUBBLE_LAYOUT_STYLE_ICON_ONLY || self.layoutStyle == .BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP ? bubbleContentSize.height * self.proportionOfIcon : bubbleContentSize.height * self.proportionOfIcon
        var iconFrame: CGRect = CGRect(x: baseX, y: baseY + (bubbleContentSize.height - iconWidth) / 2, width: iconWidth, height: iconWidth)
        switch self.layoutStyle {
        case .BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2
            iconFrame.origin.y = baseY
        case .BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2
            iconFrame.origin.y = baseY + bubbleContentSize.height - iconWidth
        case .BUBBLE_LAYOUT_STYLE_ICON_RIGHT_TITLE_LEFT:
            iconFrame.origin.x += bubbleContentSize.width - iconWidth
        case .BUBBLE_LAYOUT_STYLE_TITLE_ONLY:
            iconFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        case .BUBBLE_LAYOUT_STYLE_ICON_ONLY:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2
        default: break
        }
        return iconFrame
    }
    
    /// 计算泡泡控件中的标题控件的frame
    ///
    /// - returns: 标题控件的frame
    func calTitleViewFrame() -> CGRect {
        let iconFrame: CGRect = self.calIconViewFrame()
        let bubbleContentSize = CGSize(width: self.bubbleSize.width * (1 - self.proportionOfPadding.x * 2), height: self.bubbleSize.height * (1 - self.proportionOfPadding.y * 2))
        let baseX: CGFloat = self.bubbleSize.width * self.proportionOfPadding.x
        let baseY: CGFloat = self.bubbleSize.height * self.proportionOfPadding.y
        let titleWidth: CGFloat = self.layoutStyle == .BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM || self.layoutStyle == .BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP || self.layoutStyle == .BUBBLE_LAYOUT_STYLE_TITLE_ONLY ? bubbleContentSize.width : bubbleContentSize.width * (1 - self.proportionOfSpace) - iconFrame.size.width
        let titleHeight: CGFloat = (self.title as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: self.titleFontSize)]).height
        var titleFrame: CGRect = CGRect(x: baseX, y: baseY + (bubbleContentSize.height - titleHeight) / 2, width: titleWidth, height: titleHeight)
        switch self.layoutStyle {
        case .BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM:
            titleFrame.origin.y = iconFrame.origin.y + iconFrame.size.height + bubbleContentSize.height * self.proportionOfSpace
        case .BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT:
            titleFrame.origin.x = iconFrame.origin.x + iconFrame.size.width + bubbleContentSize.width * self.proportionOfSpace
        case .BUBBLE_LAYOUT_STYLE_ICON_ONLY:
            titleFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        case .BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP:
            titleFrame.origin.y  = baseY + (bubbleContentSize.height * (1 - self.proportionOfIcon - self.proportionOfSpace) - titleHeight) / 2
        default: break
        }
        return titleFrame
    }

}
