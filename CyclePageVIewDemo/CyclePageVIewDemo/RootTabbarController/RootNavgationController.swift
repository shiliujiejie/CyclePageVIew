//
//  RootNavgationController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

/// 导航栏设置
class RootNavigationController: UINavigationController {
    
    var config: RootTabBarConfig! {
        didSet {
            navigationBar.setBackgroundImage(config.navBarBackgroundImg ?? UIColor.creatImageWithColor(color: config.navBarBackgroundColor!,size: CGSize(width: screenWidth, height: self.navigationBar.bounds.height)), for: .any, barMetrics: .default)
            navigationBar.shadowImage = UIColor.creatImageWithColor(color: config.navBarshadowColor!, size: CGSize(width: screenWidth, height: 0.5))
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : config.navBarTitleColor!, NSAttributedString.Key.font : config.navBarTitleFont!]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.defaultSetting()
    }
    
    func defaultSetting() {
        //导航栏的背景色与标题设置
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.isTranslucent = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            //导航栏返回按钮自定义
            let backButton = UIButton(frame:CGRect.init(x: 15, y: 2, width: 50, height: 40))
            backButton.setImage(config.navBackButtonImage!, for: .normal)
            backButton.addTarget(self, action:#selector(self.didBackButton(sender:)), for: .touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:backButton)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    //点击事件
    @objc func didBackButton(sender: UIButton) {
        self.popViewController(animated:true)
    }
}
