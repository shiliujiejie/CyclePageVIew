//
//  BaseViewController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = ""
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.backButton.isHidden = true
        bar.delegate = self
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        layoutNavBar()
    }
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarFrame.height + 44)
        }
    }
}

// MARK: - CNavigationBarDelegate
extension BaseViewController: CNavigationBarDelegate {
    func backAction() {
        dismiss(animated: false, completion: nil)
    }
}
