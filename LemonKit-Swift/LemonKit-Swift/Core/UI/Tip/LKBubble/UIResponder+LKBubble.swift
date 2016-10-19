//
//  UIResponder+LKBubble.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/10/19.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit


// MARK: - 针对LKBubble对UIResponder的扩展
extension UIResponder{
    
    /// 获取默认的显示成功的泡泡信息对象，可以在此基础之上自定义
    ///
    /// - returns: 泡泡信息描述对象
    func getDefaultRightBubbleInfo() -> LKBubbleInfo {
        let info: LKBubbleInfo = LKBubbleInfo()
        info.iconAnimation = {(layer: CAShapeLayer) -> Void in
            let STROKE_WIDTH: CGFloat = 3// 默认的划线线条宽度
            // 绘制外部透明的圆形
            let circlePath: UIBezierPath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - CGFloat(STROKE_WIDTH), startAngle: CGFloat(0 * M_PI) / 180, endAngle: CGFloat(360 * M_PI) / 180.0, clockwise: false)
            // 创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer()
            alphaLineLayer.path = circlePath.cgPath// 设置透明圆形的绘图路径
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor// 设置图层的透明圆形的颜色
            alphaLineLayer.lineWidth = STROKE_WIDTH// 设置圆形的线宽
            alphaLineLayer.fillColor = UIColor.clear.cgColor// 填充颜色透明
            
            layer.addSublayer(alphaLineLayer)// 把外部半透明圆形的图层加到当前图层上
            
            // 设置当前图层的绘制属性
            layer.fillColor = UIColor.clear.cgColor
            layer.lineCap = kCALineCapRound// 圆角画笔
            layer.lineWidth = STROKE_WIDTH
            
            // 半圆+动画的绘制路径初始化
            let path: UIBezierPath = UIBezierPath()
            // 绘制大半圆
            path.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: CGFloat(67 * M_PI / 180), endAngle: CGFloat(-158 * M_PI / 180), clockwise: false)
            // 绘制对号第一笔
            path.addLine(to: CGPoint(x: layer.frame.size.width * 0.42, y: layer.frame.size.width * 0.68))
            // 绘制对号第二笔
            path.addLine(to: CGPoint(x: layer.frame.size.width * 0.75, y: layer.frame.size.width * 0.35))
            // 把路径设置为当前图层的路径
            layer.path = path.cgPath
            
            let timing: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.1)
            // 创建路径顺序绘制的动画
            let animation: CABasicAnimation = CABasicAnimation(keyPath:  "strokeEnd")
            animation.duration = 0.5// 动画使用时间
            animation.fromValue = NSNumber(value: 0.0)// 从头
            animation.toValue = NSNumber(value: 1.0)// 画到尾
            // 创建路径顺序从结尾开始消失的动画
            let strokeStartAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = 0.4// 动画使用时间
            strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2;// 延迟0.2秒执行动画
            strokeStartAnimation.fromValue = NSNumber(value:  0.0)// 从开始消失
            strokeStartAnimation.toValue = NSNumber(value: 0.74)// 一直消失到整个绘制路径的74%，这个数没有啥技巧，一点点调试看效果，希望看此代码的人不要被这个数值怎么来的困惑
            strokeStartAnimation.timingFunction = timing
            layer.strokeStart = 0.74// 设置最终效果，防止动画结束之后效果改变
            layer.strokeEnd = 1.0
            layer.add(animation, forKey: "strokeEnd")
            layer.add(strokeStartAnimation, forKey: "strokeStart")
        }
        info.title = "成功"
        info.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        info.iconColor = UIColor(red: 0 / 255.0, green: 205 / 255.0, blue: 0, alpha: 1)
        info.titleColor = .black
        info.bubbleSize = CGSize(width: 200, height: 100)
        return info
    }
    
    /// 展示一个带对号的提示信息
    ///
    /// - parameter title:         要提示的标题
    /// - parameter autoCloseTime: 自动关闭的时间
    func showRightWithTitle(title: String , autoCloseTime: CGFloat) -> Void {
        let info: LKBubbleInfo = self.getDefaultRightBubbleInfo()
        info.title = title
        LKBubbleView.defaultBubbleView().showWithinfo(info: info, autoCloseTime: 3)
    }
    
    /// 获取默认的显示加载中的泡泡信息对象，可以在此基础之上自定义
    ///
    /// - returns: 泡泡信息描述对象
    func getDefaultRoundProgressBubbleInfo() -> LKBubbleInfo {
        let info: LKBubbleInfo = LKBubbleInfo()
        info.iconAnimation = {(layer: CAShapeLayer) -> Void in
            let STROKE_WIDTH: CGFloat = 3
            
            // 绘制外部透明的圆形
            let circlePath: UIBezierPath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - CGFloat(STROKE_WIDTH), startAngle: CGFloat(0 * M_PI) / 180, endAngle: CGFloat(360 * M_PI) / 180.0, clockwise: false)
            // 创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer()
            alphaLineLayer.path = circlePath.cgPath// 设置透明圆形的绘图路径
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor// 设置图层的透明圆形的颜色
            alphaLineLayer.lineWidth = STROKE_WIDTH// 设置圆形的线宽
            alphaLineLayer.fillColor = UIColor.clear.cgColor// 填充颜色透明
            
            layer.addSublayer(alphaLineLayer)// 把外部半透明圆形的图层加到当前图层上
            
            let drawLayer: CAShapeLayer = CAShapeLayer()
            let progressPath: UIBezierPath = UIBezierPath()
            progressPath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: CGFloat(0 * M_PI / 180), endAngle: CGFloat(360 * M_PI / 180), clockwise: true)
            
            drawLayer.lineWidth = STROKE_WIDTH
            drawLayer.fillColor = UIColor.clear.cgColor
            drawLayer.path = progressPath.cgPath
            drawLayer.frame = drawLayer.bounds
            drawLayer.strokeColor = layer.strokeColor
            layer.addSublayer(drawLayer)
            
            let progressRotateTimingFunction: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.80, 0.75, 1.00)
            
            // 开始划线的动画
            let progressLongAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            progressLongAnimation.fromValue = NSNumber(value: 0.0)
            progressLongAnimation.toValue = NSNumber(value: 1.0)
            progressLongAnimation.duration = 2
            progressLongAnimation.timingFunction = progressRotateTimingFunction
            progressLongAnimation.repeatCount = 100000
            // 线条逐渐变短收缩的动画
            let progressLongEndAnimation: CABasicAnimation = CABasicAnimation(keyPath:  "strokeStart")
            progressLongEndAnimation.fromValue = NSNumber(value: 0.0)
            progressLongEndAnimation.toValue = NSNumber(value: 1.0)
            progressLongEndAnimation.duration = 2
            let strokeStartTimingFunction: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.65, 0.0, 1.0, 1.0)
            progressLongEndAnimation.timingFunction = strokeStartTimingFunction
            progressLongEndAnimation.repeatCount = 100000
            // 线条不断旋转的动画
            let progressRotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            progressRotateAnimation.fromValue = NSNumber(value: 0.0)
            progressRotateAnimation.toValue = NSNumber(value: M_PI / 180 * 360)
            progressRotateAnimation.repeatCount = 100000
            progressRotateAnimation.duration = 6
            
            drawLayer.add(progressLongAnimation, forKey: "strokeEnd")
            drawLayer.add(progressRotateAnimation, forKey: "transform.rotation.z")
            drawLayer.add(progressLongEndAnimation, forKey: "trokeStart")
        }
        info.title = "请稍候..."
        info.bubbleSize = CGSize(width: 140, height: 120)
        info.maskColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        info.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        return info
    }
    
    /// 展示一个圆形的无限循环的进度条
    ///
    /// - parameter title: 要提示的标题
    func showRoundProgressWithTitle(title: String) -> Void {
        let info: LKBubbleInfo = self.getDefaultRoundProgressBubbleInfo()
        info.title = title
        LKBubbleView.defaultBubbleView().showWithInfo(info: info)
    }
    
    func getDefaultErrorBubbleInfo() -> LKBubbleInfo {
        let info: LKBubbleInfo = LKBubbleInfo()
        
        let STROKE_WIDTH: CGFloat = 3
        
        info.iconAnimation = {(layer: CAShapeLayer) -> Void in
            // 绘制外部透明的圆形
            let circlePath: UIBezierPath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: CGFloat(0 * M_PI) / 180, endAngle: CGFloat(360 * M_PI) / 180.0, clockwise: false)
            // 创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer()
            alphaLineLayer.path = circlePath.cgPath// 设置透明圆形的绘图路径
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor// 设置图层的透明圆形的颜色
            alphaLineLayer.lineWidth = STROKE_WIDTH// 设置圆形的线宽
            alphaLineLayer.fillColor = UIColor.clear.cgColor// 填充颜色透明
            
            layer.addSublayer(alphaLineLayer)// 把外部半透明圆形的图层加到当前图层上
            
            // 开始画叉的两条线，首先画逆时针旋转的线
            let leftLayer: CAShapeLayer = CAShapeLayer()
            // 设置当前图层的绘制属性
            leftLayer.frame = layer.bounds
            leftLayer.fillColor = UIColor.clear.cgColor
            leftLayer.lineCap = kCALineCapRound
            leftLayer.lineWidth = STROKE_WIDTH
            leftLayer.strokeColor = layer.strokeColor
            
            // 半圆+动画的绘制路径初始化
            let leftPath: UIBezierPath = UIBezierPath()
            // 绘制大半圆
            leftPath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: CGFloat(-43 * M_PI / 180), endAngle: CGFloat(-315 * M_PI / 180), clockwise: false)
            leftPath.addLine(to: CGPoint(x: layer.frame.size.width * 0.35, y: layer.frame.size.width * 0.35))
            // 把路径设置为当前图层的路径
            leftLayer.path = leftPath.cgPath
            
            layer.addSublayer(leftLayer)
            
            // 逆时针旋转的线
            let rightLayer: CAShapeLayer = CAShapeLayer()
            // 设置当前图层的绘制属性
            rightLayer.frame = layer.bounds
            rightLayer.fillColor = UIColor.clear.cgColor
            rightLayer.lineCap = kCALineCapRound
            rightLayer.lineWidth = STROKE_WIDTH
            rightLayer.strokeColor = layer.strokeColor
            
            // 半圆+动画的绘制路径初始化
            let rightPath: UIBezierPath = UIBezierPath()
            // 绘制大半圆
            rightPath.addArc(withCenter: CGPoint(x: layer.frame.size.width / 2 , y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: CGFloat(-43 * M_PI / 180), endAngle: CGFloat(-315 * M_PI / 180), clockwise: false)
            rightPath.addLine(to: CGPoint(x: layer.frame.size.width * 0.35, y: layer.frame.size.width * 0.35))
            // 把路径设置为当前图层的路径
            rightLayer.path = rightPath.cgPath
            
            layer.addSublayer(rightLayer)
            
            let timing: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.1)
            // 创建路径顺序绘制的动画
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5
            animation.fromValue = NSNumber(value: 0.0)// 从头
            animation.toValue = NSNumber(value: 1.0)// 画到尾
            // 创建路径顺序从结尾开始消失的动画
            let strokeStartAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = 0.4// 动画使用时间
            strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2// 延迟0.2秒执行动画
            strokeStartAnimation.fromValue = NSNumber(value: 0.0)// 从开始消失
            strokeStartAnimation.toValue = NSNumber(value: 0.84)// 一直消失到整个绘制路径的84%，这个数没有啥技巧，一点点调试看效果，希望看此代码的人不要被这个数值怎么来的困惑
            strokeStartAnimation.timingFunction = timing
            
            leftLayer.strokeStart = 0.84// 设置最终效果，防止动画结束之后效果改变
            leftLayer.strokeEnd = 1.0
            rightLayer.strokeStart = 0.84// 设置最终效果，防止动画结束之后效果改变
            rightLayer.strokeEnd = 1.0
            
            leftLayer.add(animation, forKey: "strokeEnd")// 添加俩动画
            leftLayer.add(strokeStartAnimation, forKey: "strokeStart")
            rightLayer.add(animation, forKey: "strokeEnd")
            rightLayer.add(strokeStartAnimation, forKey: "strokeStart")
        }
        info.title = "发生了一个错误"
        info.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        info.iconColor = UIColor(red: 255 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 1)
        info.titleColor = .black
        info.layoutStyle = .BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT
        info.bubbleSize = CGSize(width: 200 , height: 100)
        return info
    }
    
    /// 展示一个带错误X的提示信息
    ///
    /// - parameter title:         提示信息的标题
    /// - parameter autoCloseTime: 自动关闭的时间
    func showErrorWithTitle(title: String ,autoCloseTime: CGFloat) -> Void {
        let info: LKBubbleInfo = self.getDefaultErrorBubbleInfo()
        info.title = title
        LKBubbleView.defaultBubbleView().showWithinfo(info:  info, autoCloseTime:  autoCloseTime)
    }
    
}
