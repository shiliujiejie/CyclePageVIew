# CyclePageVIew

     新概念 banner 组件 UIImageView + Timer + PageControl   搞定 banner 循环
    
     支持下拉缩放的 banner 封装  (swift 4.2 )，支持3种动画切换，封装简单


## | ScreenRecording  |
|:---------:|:-------:|:---------:|
| ![Recording](https://github.com/shiliujiejie/adResource/raw/master/bannerdemo.gif) | ![Recordings](https://github.com/shiliujiejie/adResource/raw/master/ebannerdemo1.gif)) | 

## Use 

## 简单使用：
     
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
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          view.addSubview(cycleView)
          cycleView.setImages(imageNames)

     }
     
## 配合scrollView （tableView + collectionView） 带下拉放大  使用 ：
     
     ( 🌟🌟 不要放大的，请注释：scrollViewDidScroll(_ scrollView: UIScrollView)方法 🌟🌟) 
     
     override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
        view.addSubview(cycleView)
     
     // 设置tableView的top为imageView的高度，第一行cell会偏移到imageView的底部
        tableView.contentInset = UIEdgeInsets(top: imageHeight + topInset, left: 0, bottom: 0, right: 0)
     
        cycleView.setImages(imageNames)
     
     // [weak self]
        cycleView.pageClickAction = { (index) in
           print("click at Index == \(index)")
        }
     }

    在  func scrollViewDidScroll(_ scrollView: UIScrollView) 中 设置 frame
