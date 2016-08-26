 //
//  HF3D_ADView.swift
//  3D轮播图
//
//  Created by taoyi-two on 16/8/23.
//  Copyright © 2016年 fench. All rights reserved.
//

import UIKit

struct HF3DAnimationOptions: OptionSetType {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    static let All = HF3DAnimationOptions(rawValue:1)                           // 所有动画随机播放
    static let Fade = HF3DAnimationOptions (rawValue:1<<1)                      // 淡入淡出
    static let MoveIn = HF3DAnimationOptions (rawValue:1<<2)                    // 移入新视图
    static let Reveal = HF3DAnimationOptions (rawValue:1<<3)                    // 移开视图
    static let Cube = HF3DAnimationOptions (rawValue:1<<4)                      // 立体翻转
    static let SuckEffect = HF3DAnimationOptions (rawValue:1<<5)                // 收缩 抽走
    static let RippleEffect = HF3DAnimationOptions (rawValue:1<<6)              // 水滴效果
    static let PageCurl = HF3DAnimationOptions (rawValue:1<<7)                  // 翻页
    static let PageUnCurl = HF3DAnimationOptions (rawValue:1<<8)                // 反向翻页
    static let CameraIrisHollowOpen = HF3DAnimationOptions (rawValue:1<<9)      // 打开相机效果
    static let CameraIrisHollowClose = HF3DAnimationOptions (rawValue:1<<10)    // 关闭相机效果
    static let oglFlip = HF3DAnimationOptions(rawValue:1<<11)                   // 上下翻转
}
 
 @objc protocol HF3DViewDelegate : NSObjectProtocol{
   optional
   func imageDidClick(adView: HF3D_ADView, index: Int)
 }

class HF3D_ADView: UIView {
    var pictures : [UIImage]?
    /// 是否需要动画 默认为true
    var shouldAnimation :  Bool? {
        didSet{
            if !shouldAnimation! {
                imageView.removeFromSuperview()
                self.addSubview(scrollView)
            }
        }
    }
    /// 设置跳转间隔时间
    var timeInterval : NSTimeInterval?{
        didSet{
            self.stopTimer()
            self.startTimer(timeInterval!)
        }
    }
    /// 设置动画类型  可设置多种动画 随机播放动画
    var animationOptins : HF3DAnimationOptions?{
        didSet{
            let numberStr = String(animationOptins!.rawValue, radix : 2)
            currentAnimations?.removeAll()
            if numberStr.characters.count == 1 {
                currentAnimations?.appendContentsOf(animations)
                return
            }
            for (i,c) in numberStr.characters.enumerate() {
                if c == "1" {
                   let index = numberStr.characters.count - i - 1
                    currentAnimations?.append(animations[index - 1])
                }
            }
        }
    }
    /// 设置动画subType
    var subType : String?
    var delegate : HF3DViewDelegate?
    
    
    // 私有变量、常量
    private let imageView = UIImageView()
    private let pageControll = UIPageControl()
    private let scrollView = UIScrollView()
    private var timer : NSTimer?
    private var currentIndex : NSInteger?
    private let animations = ["fade", "moveIn", "reveal", "cube", "suckEffect", "rippleEffect", "pageCurl", "pageUnCurl", "cameraIrisHollowOpen", "cameraIrisHollowClose", "oglFlip"]
    private lazy var currentAnimations: [String]? = { return []}()
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化方法
    convenience init(frame:CGRect, pictures:[UIImage], timeInterval:NSTimeInterval){
        self.init(frame:frame)
        self.pictures = pictures
        self.timeInterval = timeInterval
        shouldAnimation = true
        currentIndex = 0;
        
        // 初始化imageView
        imageView.image = pictures[0]
        imageView.backgroundColor = UIColor.greenColor()
        imageView.userInteractionEnabled = true
        self.addGesture()
        self.addSubview(imageView)
        
        // 初始化scrollView
        scrollView.frame = self.bounds
        
        // 初始化pageControll
        pageControll.numberOfPages = pictures.count
        pageControll.pageIndicatorTintColor = UIColor.whiteColor()
        pageControll.currentPageIndicatorTintColor = UIColor.blueColor()
        self.addSubview(pageControll)
        
        // 开启定时器 默认间隔为3.0s
        self.startTimer(3.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        pageControll.frame = CGRectMake(0, frame.size.height-25, frame.size.width, 25)
    }
    
    // 添加手势
    private func addGesture(){
        // 左滑手势
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(HF3D_ADView.leftSwipe(_:)))
        leftGesture.direction = .Left
        imageView.addGestureRecognizer(leftGesture)
        
        // 右滑手势
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(HF3D_ADView.rightSwipe(_:)))
        rightGesture.direction = .Right
        imageView.addGestureRecognizer(rightGesture)
        
        // 点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HF3D_ADView.tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // 左滑手势
    @objc private func leftSwipe(gesture: UISwipeGestureRecognizer){
        self.stopTimer()
        if gesture.state == .Ended {
            self.startTimer(timeInterval!)
        }
        self.transitionAmination(true)
        
    }
    // 右滑手势
    @objc private func rightSwipe(gestrue: UISwipeGestureRecognizer){
        self.stopTimer()
        if gestrue.state == .Ended {
            self.startTimer(timeInterval!)
        }
        self.transitionAmination(false)
    }
    
    // 点击手势
    @objc private func tapGesture(gesture: UITapGestureRecognizer){
        if ((self.delegate?.respondsToSelector(#selector(self.delegate?.imageDidClick(_:index:)))) == true) {
            self.delegate?.imageDidClick!(self, index: currentIndex! + 1)
        }
    }
    // 开启定时器
    private func startTimer(timeInterval:NSTimeInterval) {
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(HF3D_ADView.changeImage), userInfo: nil, repeats: true)
    }
    
    // 停止定时器
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    // 修改图片
    @objc private func changeImage(isNext:Bool) {
        self.transitionAmination(true)
    }
    
    // 转场动画
    private func transitionAmination(isNext: Bool){
        let transtion = CATransition()
        transtion.delegate = self
        let index = arc4random_uniform(UInt32((currentAnimations?.count)!))
        transtion.type = currentAnimations![Int(index)]
        transtion.duration = 1.0
        transtion.subtype = subType
        imageView.image = self.getImage(isNext)
        imageView.layer.addAnimation(transtion, forKey:"transition")
        
    }
    
    // 获取图片
    private func getImage(isNext: Bool) -> UIImage{
        if isNext {
            currentIndex = (currentIndex! + 1) % (pictures?.count)!
            pageControll.currentPage = currentIndex!
        } else {
            currentIndex = (currentIndex! - 1 + (pictures?.count)!) % (pictures?.count)!
            pageControll.currentPage = currentIndex!
        }
        
        let image = pictures![currentIndex!]
        return image
    }
}
