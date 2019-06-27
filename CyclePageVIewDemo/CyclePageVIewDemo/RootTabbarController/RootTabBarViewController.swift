//
//  RootTabBarViewController.swift
//  unionMerchant
//
//  Created by simpsons on 2017/8/16.
//  Copyright © 2017年 simpsons. All rights reserved.
//

import UIKit
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let safeAreaTopHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let safeAreaBottomHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone"  ? 34 : 0)

class RootTabBarViewController: UITabBarController {

    
    private lazy var tabbar: RootTabBar = {
        let tab = RootTabBar()
        tab.backgroundImage = config.tabBarBackgroundImg ?? UIColor.creatImageWithColor(color: config.tabBarBackgroundColor!,size: CGSize(width: screenWidth, height: self.tabBar.bounds.height))
        tab.addDelegate = self
        return tab
    }()
    
    private var config = RootTabBarConfig()

    private var tabBarModels = [RootTabBarModel]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = UIColor.colorWithHexString("f3f3f5")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: RootTabBarConfig, tabBars: [RootTabBarModel]) {
        self.config = config
        self.tabBarModels = tabBars
        self.config.viewControllerCount = tabBarModels.count
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        super.viewDidLoad()
        self.setValue(tabbar, forKey: "tabBar")
        self.setConntrollers()
        tabbar.config(config)
        // 淡化 tabBar 黑线
        self.tabBar.shadowImage = UIColor.creatImageWithColor(color: config.tabBarShadowColor!,size: CGSize(width: screenWidth, height: 0.5))
    }
    
    func setConntrollers() {
        if self.config.viewControllerCount%2 != 0 { // 不为双数，只能为默认类型， 中心圆设置不起效
            config.tabBarStyle = .normal
        }
        
        for i in 0 ..< self.tabBarModels.count {
            let model = self.tabBarModels[i]
            //创建导航控制器
            let nav = RootNavigationController.init(rootViewController: model.controller)
            /// 配置 导航栏
            nav.config = config
            
            //1.创建tabbarItem
            let barItem = UITabBarItem.init(title: model.title, image: UIImage(named: model.imageNormal)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: model.imageSelected)?.withRenderingMode(.alwaysOriginal))
            
            //2.更改字体颜色
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : config.titleColorNormal!], for: .normal)
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : config.titleColorSelected!], for: .selected)
            
            //设置标题
           // model.controller.title = model.title
            
            //设置根控制器
            model.controller.tabBarItem = barItem
            
            //添加到当前控制器
            addChild(nav)
        }
    }
}

extension RootTabBarViewController: RootTabBarDelegate {
    /// 中间特殊按钮执行方法
    func addClick() {
        if config.centerViewController != nil {
            if config.isAnimation { // 有动画，延迟0.6秒
                self.perform(#selector(centerClick), with: nil, afterDelay: 0.35)
            } else {
                centerClick()
            }
        }
    }
    
    @objc func centerClick() {
        print("center click")
        let nav = RootNavigationController(rootViewController: config.centerViewController!)
        self.present(nav, animated: true, completion: nil)
    }
}
