//
//  RootTabBarConfig.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

/// Tabbar
///
/// - typeNormal: 常规模式
/// - typeCenter: 中间放大
enum RootTabBarStyle: Int {
    case normal = 0
    case center = 1
}
/// 点击动画
///
/// - scaleDown: scale 缩小
/// - scaleUp: scale 放大
/// - rotation: 旋转
enum RootTabBarAnimation: Int {
    case scaleDown = 0
    case scaleUp = 1
    case rotation = 2
}

class RootTabBarConfig: NSObject {
    
    
    // MARK: - isTypeCenter
    var viewControllerCount: Int = 2
    
    /// 中间按钮点击 弹出
    var centerViewController: UIViewController?
    
    // MARK: - tabBar Setting
    
    /// tabBar风格
    var tabBarStyle: RootTabBarStyle = .normal
    /// 点击动画 是否开启
    var isAnimation: Bool = false
    
    /// 点击动画类型， 目前只有缩放， todo: 1 转动  2 弹性效果  3 裂变
    var animation: RootTabBarAnimation = .scaleDown
    
    /// 中间按钮图片(RootTabBarType == .center 时设置，normal 时设置无效)
    var centerImage: UIImage? = UIImage(named: "center_add")
    
    /// 中心按钮j 上浮高度
    var centerInsetUp: CGFloat = 15.0
    
    /// bar 背景色
    var tabBarBackgroundColor: UIColor? = UIColor(white: 1.0, alpha: 0.95)
    /// bar 背景图片（优先级比 背景色 高  设置后，背景色不再起效)
    var tabBarBackgroundImg: UIImage?
    
    /// 文字 非选中 色
    var titleColorNormal: UIColor? = UIColor(r: 69, g: 69, b: 69)
    /// 文字 选中 色
    var titleColorSelected: UIColor? = UIColor(r: 255, g: 42, b: 49)
    /// 顶部线条 颜色
    var tabBarShadowColor: UIColor? = UIColor(r: 249, g: 249, b: 249, a: 1)
    
    // MARK: - navigationBar Setting
    
    /// 导航栏 背景色
    var navBarBackgroundColor: UIColor? = UIColor(white: 1.0, alpha: 0.8)
    /// navbar 背景图片（优先级比 背景色 高  设置后，背景色不再起效)
    var navBarBackgroundImg: UIImage?
    
    /// 导航栏 底部线条 颜色
    var navBarshadowColor: UIColor? = UIColor(r: 249, g: 249, b: 249, a: 1)
    /// 导航栏 标题 颜色
    var navBarTitleColor: UIColor? = UIColor(r: 51, g: 51, b: 51)
    /// 导航栏 title 字体
    var navBarTitleFont: UIFont? = UIFont.systemFont(ofSize: 17)
    /// 导航栏返回图片
    var navBackButtonImage: UIImage? = UIImage(named: "navBackDefault")
    
}

/// tabBarModel
struct RootTabBarModel {
    var title: String
    var imageNormal: String
    var imageSelected: String
    var controller: UIViewController
}
