//
//  ViewController.swift
//  CyclePageVIewDemo
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configTabBar()
    }

    private func configTabBar() {
        
        let tabBarNormalImages = ["Main_N","book_N","task_N","acount_N"]
        let tabBarSelectedImages = ["Main_S","book_S","task_S","acount_S"]
        let tabBarTitles = ["首页","消息","发现","我的"]
        let controllers = [TableScaleController(), SingleScrollController(), CollectionController(), UserCenterController()]
        
        var tabBars =  [RootTabBarModel]()
        
        for i in 0 ..< tabBarNormalImages.count {
            let rootModel = RootTabBarModel.init(title: tabBarTitles[i], imageNormal: tabBarNormalImages[i], imageSelected: tabBarSelectedImages[i], controller: controllers[i])
            tabBars.append(rootModel)
        }
        let tabbarVC = RootTabBarViewController.init(config: getConfigModel(), tabBars: tabBars)
        self.addChild(tabbarVC)
        self.view.addSubview(tabbarVC.view)
    }
    
    private func getConfigModel() -> RootTabBarConfig {
        let rootConfig = RootTabBarConfig()
        rootConfig.tabBarStyle = .center
        rootConfig.isAnimation = true
        rootConfig.animation = .rotation
        rootConfig.tabBarBackgroundColor = UIColor(white: 0.7, alpha: 0.99)
        rootConfig.navBarBackgroundColor = UIColor(white: 0.7, alpha: 0.99)
        
        return rootConfig
    }
}

