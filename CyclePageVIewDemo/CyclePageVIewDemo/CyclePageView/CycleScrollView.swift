//
//  CycleScrollView.swift
//  CyclePageVIewDemo
//
//  Created by mac on 2019/10/20.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class CycleScrollView: UIView {

    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CyclePageScrollCell.classForCoder(), forCellWithReuseIdentifier: CyclePageScrollCell.cellId)
        return collection
    }()
    
    var pageClickAction:((_ index: Int)->Void)?
    
    private var timer: Timer?
    private var configModel: CyclePageConfig!
    private var images = [String]()
    private var titles: [String]?
    private var pageControl: PillPageControl = {
        let indicator = PillPageControl()
        return indicator
    }()
    private var currentIndex: Int = 0
    private var controlW: CGFloat = 0

    init(frame: CGRect, config: CyclePageConfig) {
        super.init(frame: frame)
        configModel = config
        backgroundColor = UIColor.clear
        addSubview(collectionView)
        layoutPageSubviews()
        self.layer.cornerRadius = config.cycleCornerRadius
        self.layer.masksToBounds = true
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
    
    func setImages(imageUrls: [String], titles: [String]?) {
        
        timer?.invalidate()
        timer = nil

        images = imageUrls
        if images.count > 0 {
            collectionView.reloadData()
        }
        if let allTitles = titles, allTitles.count > 0 {
            self.titles = allTitles
            collectionView.reloadData()
        }
        
        if images.count > 1 {
            /// 配置指示器
            configIndicator()/// 设置切换时间
            runTimer()
        }
    }
    
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
                strongSelf.collectionView.scrollToItem(at: IndexPath.init(item: strongSelf.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            } else {
                strongSelf.currentIndex += 1
                strongSelf.collectionView.scrollToItem(at: IndexPath.init(item: strongSelf.currentIndex, section: 0), at: .centeredHorizontally, animated: strongSelf.configModel.isAnimation)
            }
           // strongSelf.pageControl.progress = CGFloat(strongSelf.currentIndex)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CycleScrollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CyclePageScrollCell.cellId, for: indexPath) as! CyclePageScrollCell
        if configModel.isLocalImage {
            cell.itemImage.image = UIImage(named: self.images[indexPath.item])
        } else {
            if let url = URL(string: self.images[indexPath.item]) {
                cell.itemImage.kf.setImage(with: url, placeholder: self.configModel.placeHolderImage, options: [.transition(.fade(0.2))])
            }
        }
        if let allTitles = self.titles, allTitles.count > 0 {
            cell.titleLab.text = "\(allTitles[indexPath.item])"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        pageClickAction?(indexPath.item)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return configModel.itemSize
    }
   
    
}
extension CycleScrollView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //timer?.fireDate = Date.distantFuture  // 拖动开始，timer先暂停
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let index = offSetX/configModel.itemSize.width
        currentIndex = Int(index)
         pageControl.progress = CGFloat(currentIndex)
//        if index > CGFloat(images.count - 1) { // 最后一张，滑动，到第一章
//            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
//            currentIndex = 0
//        } else if index < 0.0 {  // 第一张倒滑， 到最后一张
//            timer?.fireDate = Date.distantFuture
//            collectionView.scrollToItem(at: IndexPath(item: images.count - 1, section: 0), at: .centeredHorizontally, animated: false)
//             currentIndex = images.count - 1
//        } else {
//            currentIndex = Int(index)
//        }
//        pageControl.progress = CGFloat(currentIndex)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //timer?.fireDate = Date.distantPast  // 拖动结束，timer恢复计时
    }
}

// MARK: - Layout
private extension CycleScrollView {
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}


class CyclePageScrollCell: UICollectionViewCell {
    
    static let cellId = "CyclePageScrollCell"
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(itemImage)
        contentView.addSubview(titleLab)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
private extension CyclePageScrollCell {
    func layoutPageSubviews() {
        layoutItemImage()
        layoutTitleLab()
    }
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(35)
        }
    }
    func layoutItemImage() {
        itemImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

