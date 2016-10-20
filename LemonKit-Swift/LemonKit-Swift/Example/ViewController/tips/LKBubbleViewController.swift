//
//  LKBubbleViewController.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/10/20.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class LKBubbleViewController: UIViewController {

    @IBAction func showSuccessBubble(_ sender: UIButton) {
        self.showRightWithTitle(title:  "添加成功", autoCloseTime:  2)
    }
    
    @IBAction func showProgressBubble(_ sender: UIButton) {
        self.showRoundProgressWithTitle(title: "加载中")
        // swift 3 中的延迟执行，相当于oc中的dispatch_after
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.showRightWithTitle(title:  "加载完毕", autoCloseTime: 2)
        }
    }
    
    @IBAction func showErrorBubble(_ sender: UIButton) {
        self.showErrorWithTitle(title: "加载失败", autoCloseTime: 2)
    }
    
    @IBAction func showFrameAnimationBubble(_ sender: UIButton) {
        let frameInfo: LKBubbleInfo = LKBubbleInfo()
        var icons:Array<UIImage> = Array()
        
        for i in 1..<9 {
            icons.append(UIImage(named: String(format: "lkbubble%d.jpg", i))!)
        }
        frameInfo.iconArray = icons
        // 在数组中依次放入多张图片即可实现多图循环播放
        frameInfo.backgroundColor = UIColor(red:  238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 1)
        // 动画的帧动画播放间隔
        frameInfo.frameAnimationTime = 0.15
        frameInfo.title = "正在加载中..."
        frameInfo.titleColor = .gray
        LKBubbleView.defaultBubbleView().showWithInfo(info: frameInfo)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { 
            self.showSingleIconBubble(sender)
        }
    }
    
    @IBAction func showSingleIconBubble(_ sender: UIButton) {
        let iconInfo: LKBubbleInfo = LKBubbleInfo()
        // 把图标数组里面设置只有一张图片即可单图固定图标
        iconInfo.iconArray = [UIImage(named: "lkbubble-warning")!]
        iconInfo.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        iconInfo.titleColor = .darkGray
        iconInfo.locationStyle = .BUBBLE_LOCATION_STYLE_BOTTOM
        iconInfo.layoutStyle = .BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT
        iconInfo.title = "这是一个警告的泡泡控件"
        iconInfo.proportionOfDeviation = 0.05
        iconInfo.bubbleSize = CGSize(width: 300, height: 60)
        LKBubbleView.defaultBubbleView().showWithinfo(info: iconInfo, autoCloseTime: 2)
    }
    

}
