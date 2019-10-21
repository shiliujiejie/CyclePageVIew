//
//  CycleScrollController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

class SingleScrollController: UIViewController {
    
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.isLocalImage = true
        config.animationType = .crossDissolve
        config.transitionDuration = 4
        config.animationDuration = 1.5
        config.cycleCornerRadius = 10.0
        return config
    }()
    private lazy var cycleView: CycleScrollView = {
        let view = CycleScrollView.init(frame: CGRect(x: 15, y: 15, width: screenWidth - 30, height: 150), config: config)
        return view
    }()
    
    private lazy var cycleView1: CyclePageView = {
        
        let configM = CyclePageConfig()
        configM.animationType = .curlUp
        configM.isLocalImage = true
        configM.transitionDuration = 5
        configM.activeTintColor = UIColor.red
        configM.animationDuration = 2
        
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 210, width: screenWidth, height: 130), config: configM)
        return view
    }()
    
    private lazy var cycleView2: CyclePageView = {
        let configM = CyclePageConfig()
        configM.animationType = .flipFromBottom
        configM.isLocalImage = true
        let view = CyclePageView.init(frame: CGRect(x: 15, y: 390, width: screenWidth - 30, height: 150), config: configM)
        return view
    }()
    
    var imageNames = ["image12","image14","image15","localImg9","localImg4","localImg5","image11","localImg2","localImg3","localImg8","localImg10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        
        view.addSubview(cycleView)
        cycleView.setImages(imageUrls:imageNames, titles: nil)
        
        view.addSubview(cycleView1)
        cycleView1.setImages(imageNames.reversed())
        
        
        view.addSubview(cycleView2)
        cycleView2.setImages(imageNames)
    }
        
    

}
