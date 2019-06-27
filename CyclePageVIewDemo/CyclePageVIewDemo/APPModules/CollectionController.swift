//
//  CollectionController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit

fileprivate let topInset: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 44 : 20)

class CollectionController: BaseViewController {
    
    private let cellId = "collection"
    private let imageHeight: CGFloat = 120
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        let itemWidth: CGFloat = (UIScreen.main.bounds.size.width - 40)/3
        let itemHieght: CGFloat = itemWidth * 16/11
        let itemThridSize = CGSize(width: itemWidth, height: itemHieght)
        layout.itemSize = itemThridSize
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellId)
        return collection
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
    
    var imageNames = ["https://github.com/shiliujiejie/adResource/raw/master/image14.jpg","https://github.com/shiliujiejie/adResource/raw/master/image12.jpg","https://github.com/shiliujiejie/adResource/raw/master/banner4.png","https://github.com/shiliujiejie/adResource/raw/master/banner5.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        //self.title = "发现"
        navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(collectionView)
        
        view.addSubview(cycleView)
        
        // 设置tableView的top为imageView的高度，第一行cell会偏移到imageView的底部
        
        collectionView.contentInset = UIEdgeInsets(top: imageHeight + topInset,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        view.bringSubviewToFront(navBar)
        
        cycleView.setImages(imageNames)
        
        // [weak self]
        cycleView.pageClickAction = { (index) in
            print("click at Index == \(index)")
        }
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.contentView.backgroundColor = UIColor.yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension CollectionController: UIScrollViewDelegate {
    
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
                navBar.titleLabel.text = "发现"
            }
        }
        self.cycleView.frame = frame
    }
}
