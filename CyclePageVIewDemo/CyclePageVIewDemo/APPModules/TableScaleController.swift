//
//  ScaleController.swift
//  LayoutCollection
//
//  Created by mac on 2019/6/25.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

fileprivate let topInset: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 44 : 20)

class TableScaleController: BaseViewController {
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
    private let tableHeader: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 130 + topInset))
        return view
    }()
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.animationType = .curlUp
        return config
    }()
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight + topInset), config: config)
        return view
    }()
  
    var imageNames = ["https://github.com/shiliujiejie/adResource/raw/master/image11.png", "https://github.com/shiliujiejie/adResource/raw/master/image14.jpg","https://github.com/shiliujiejie/adResource/raw/master/image12.jpg","https://github.com/shiliujiejie/adResource/raw/master/banner4.png","https://github.com/shiliujiejie/adResource/raw/master/banner5.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "首页"
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableHeader.addSubview(cycleView)
        tableView.tableHeaderView = tableHeader
        view.addSubview(tableView)
        layoutTableView()
        
        tableView.contentInset = UIEdgeInsets(top: -topInset,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        
        cycleView.setImages(imageNames)
        
        // [weak self]
        cycleView.pageClickAction = { (index) in
            print("click at Index == \(index)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
    }

}


extension TableScaleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row ) + bingo"
        cell.contentView.backgroundColor = UIColor.purple
        return cell
    }
}

extension TableScaleController {
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
