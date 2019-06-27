//
//  UserCenterController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit
fileprivate let topInset: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 44 : 20)
class UserCenterController: BaseViewController {

    let cellReuseIdentifier = "cellId"
    let imageHeight: CGFloat = 130
    
    private var refresh: UIRefreshControl = {
        let refreshView = UIRefreshControl()
        refreshView.tintColor = UIColor.clear
        return refreshView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        //tableView.refreshControl = refresh
        return tableView
    }()
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.animationType = .crossDissolve
        return config
    }()
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight + topInset), config: config)
        return view
    }()
    private lazy var tableHeader: UIView = {
        let label = UILabel(frame: CGRect(x: 15, y: 20, width: screenWidth - 30, height: 40))
        label.text = "这是 tableViewHeader"
        label.textAlignment = .center
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        header.backgroundColor = UIColor.red
        header.addSubview(label)
        return header
    }()
    
    var imageNames = ["https://github.com/shiliujiejie/adResource/raw/master/image14.jpg", "https://github.com/shiliujiejie/adResource/raw/master/image11.png","https://github.com/shiliujiejie/adResource/raw/master/image12.jpg","https://github.com/shiliujiejie/adResource/raw/master/banner4.png","https://github.com/shiliujiejie/adResource/raw/master/banner5.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
        
        view.addSubview(cycleView)
        
        // 设置tableView的top为imageView的高度，第一行cell会偏移到imageView的底部
        tableView.contentInset = UIEdgeInsets(top: imageHeight + topInset,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        
        tableView.tableHeaderView = tableHeader
        
        view.bringSubviewToFront(navBar)
        
        cycleView.setImages(imageNames)
        
        // [weak self]
        cycleView.pageClickAction = { (index) in
            print("click at Index == \(index)")
        }
    }
    
   
    
}


extension UserCenterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row ) + bingo"
        cell.contentView.backgroundColor = UIColor.white
        return cell
    }
}

extension UserCenterController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var frame = self.cycleView.frame
        
        // imageHeight + topInset == 164 或者 140
        if offsetY <= -(imageHeight + topInset) {
            frame.origin.y = 0 // 这句代码一定要加  不然会出点问题
            frame.size.height =  -offsetY
            navBar.backgroundColor = UIColor.clear
            navBar.titleLabel.text = ""
        } else {
            frame.origin.y = -(imageHeight + topInset + offsetY)
            frame.size.height = (screenHeight >= 812.0) ? imageHeight + topInset : imageHeight
            if offsetY >= -safeAreaTopHeight {
                let alpha = (offsetY + safeAreaTopHeight) / CGFloat(safeAreaTopHeight)
                navBar.backgroundColor = UIColor(white: 0.7, alpha: alpha > 0.99 ? 0.99 : alpha)
                navBar.titleLabel.text = "我的"
            }
        }
        
        /* 🌟 这句是缩放的关键  🌟  */
        self.cycleView.frame = frame
    }
}
