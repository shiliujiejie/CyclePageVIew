//
//  CyclePageView.swift
//  RootTabBarViewController
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit
import Kingfisher

class CyclePageView: UIImageView {
    
    private var timer: Timer?
    private var configModel: CyclePageConfig!
    private var images = [String]()
    private var pageControl: PillPageControl = {
        let indicator = PillPageControl()
        return indicator
    }()
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        return tap
    }()
    private lazy var swipeLeftGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeAction(_:)))
        swipe.direction = .left
        return swipe
    }()
    private lazy var swipeRightGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeAction(_:)))
        swipe.direction = .right
        return swipe
    }()
    private var currentIndex: Int = 0
    private var controlW: CGFloat = 0
    
    var pageClickAction:((_ index: Int) -> Void)?
    
    init(frame: CGRect, config: CyclePageConfig) {
        super.init(frame: frame)
        configModel = config
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.groupTableViewBackground
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            pageControl.frame.origin.y = frame.height - 8
        }
    }
    
    func setImages(_ imageLists: [String]) {
        timer?.invalidate()
        timer = nil
        currentIndex = 0
        /// 没有数据，直接显示占位图
        if imageLists.count == 0 {
            image = configModel.placeHolderImage
            return
        }
        self.images = imageLists
        /// 加载第一条
        addImageToSelf()
        /// 添加手势
        addGesture()
        /// 只有一条数据，不滚动
        if imageLists.count == 1 { return }
        /// 配置指示器
        configIndicator()
        /// 设置切换时间
        runTimer()
    }
    
}

// MARK: - Private - Funcs
private extension CyclePageView {
    
    func configIndicator() {
        controlW = CGFloat(images.count * 17)
        pageControl.frame = CGRect(x: self.bounds.width/2 - controlW/2, y: self.bounds.height - 8 , width: controlW, height: 6)
        pageControl.activeTint = configModel.activeTintColor
        pageControl.inactiveTint = configModel.inactiveTintColor
        pageControl.pageCount = images.count
        self.addSubview(pageControl)
    }
    
    func runTimer() {
        timer = Timer.every(configModel.transitionDuration.seconds) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.currentIndex == strongSelf.images.count - 1 {
                strongSelf.currentIndex = 0
            } else {
                strongSelf.currentIndex += 1
            }
            if strongSelf.configModel.isAnimation {
                strongSelf.resetImage()
            } else {
                strongSelf.resetImageWithoutAnimation()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func resetImage() {
        if images.count == 0 { return }
        var option: UIView.AnimationOptions!
        if configModel.animationType == .crossDissolve {
            option = .transitionCrossDissolve
        } else if configModel.animationType == .flipFromBottom {
            option = .transitionFlipFromTop
        } else if configModel.animationType == .curlUp {
            option = .transitionCurlUp
        }
        UIView.transition(with: self, duration: configModel.animationDuration, options: option, animations: {
            self.addImageToSelf()
            self.pageControl.progress = CGFloat(self.currentIndex)
        }, completion: nil)
        
    }
    
    func resetImageWithoutAnimation() {
        if images.count == 0 { return }
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.1
        }) { (finish) in
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1.0
                self.addImageToSelf()
                self.pageControl.progress = CGFloat(self.currentIndex)
            }, completion: nil)
        }
    }
    
    func addImageToSelf() {
        self.layer.cornerRadius = configModel.cycleCornerRadius
        if configModel.isLocalImage {
             self.image = UIImage(named: self.images[self.currentIndex])
        } else {
            if let url = URL(string: self.images[self.currentIndex]) {
                self.kf.setImage(with: url, placeholder: self.configModel.placeHolderImage, options: [.transition(.fade(0.2))])
            }
        }
    }
}

// MARK: - Gesture Action
private extension CyclePageView {
    
    func addGesture() {
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(swipeLeftGesture)
        self.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc func tapAction() {
        pageClickAction?(currentIndex)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if images.count == 0 { return }
       // timer.invalidate()
        if sender.direction == .right {
            if currentIndex == 0 {
                currentIndex = images.count - 1
            } else {
                currentIndex -= 1
            }
            transitionCurlDown()
        }
        if sender.direction == .left {
            print("left")
            if currentIndex == images.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
            transitionCurlUp()
        }
    }
    
    func transitionCurlUp() {
        UIView.transition(with: self, duration: 0.25, options: .transitionCurlUp, animations: {
            self.addImageToSelf()
            self.pageControl.progress = CGFloat(self.currentIndex)
        }) { (finish) in
            //self.timer.start(runLoop: .current, modes: .common)
        }
    }
    
    func transitionCurlDown() {
        UIView.transition(with: self, duration: 0.35, options: .transitionCurlDown, animations: {
            self.addImageToSelf()
            self.pageControl.progress = CGFloat(self.currentIndex)
        }) { (finish) in
           // self.timer.start(runLoop: .current, modes: .common)
        }
    }
}
