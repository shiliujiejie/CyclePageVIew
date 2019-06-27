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
        config.animationType = .curlUp
        config.transitionDuration = 4
        config.animationDuration = 1.5
        return config
    }()
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 170), config: config)
        return view
    }()
    
    private lazy var cycleView1: CyclePageView = {
        let configM = CyclePageConfig()
        configM.animationType = .crossDissolve
        configM.isLocalImage = true
        config.transitionDuration = 5
        config.animationDuration = 2
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 220, width: screenWidth, height: 130), config: configM)
        return view
    }()
    
    private lazy var cycleView2: CyclePageView = {
        let configM = CyclePageConfig()
        configM.animationType = .flipFromBottom
        configM.isLocalImage = true
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 390, width: screenWidth, height: 150), config: configM)
        return view
    }()
    
    var imageNames = ["image12","image14","image15","localImg9","localImg4","localImg5","image11","localImg2","localImg3","localImg8","localImg10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        
        view.addSubview(cycleView)
        cycleView.setImages(imageNames)
        
        view.addSubview(cycleView1)
        cycleView1.setImages(imageNames.reversed())
        
        
        view.addSubview(cycleView2)
        cycleView2.setImages(imageNames)
    }
        
    

}
