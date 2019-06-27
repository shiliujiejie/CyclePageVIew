//
//  CyclePageConfig.swift
//  RootTabBarViewController
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

/// 动画类型
///
/// - crossDissolve: 隐现
/// - flipFromBottom: 翻转
/// - curlUp: 翻页
enum TransitionAnimation: Int {
    case crossDissolve = 0
    case flipFromBottom = 1
    case curlUp = 2
}

class CyclePageConfig: NSObject {
    
    /// 动画
    var animationType: TransitionAnimation = .crossDissolve
    /// 是否动画
    var isAnimation: Bool = true
    /// 切换时间
    var transitionDuration: TimeInterval = 6.0
    /// 动画时间  建议小于 transitionDuration 的一半
    var animationDuration: TimeInterval = 1.5
    /// 指示器当前 颜色
    var activeTintColor: UIColor = UIColor.green
    /// 指示器 背景颜色
    var inactiveTintColor: UIColor = UIColor(white: 1.0, alpha: 0.5)
    /// 占位图
    var placeHolderImage: UIImage? = UIImage(named: "PHC")
    /// 是否本地图片
    var isLocalImage: Bool = false
}
