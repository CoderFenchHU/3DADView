//
//  ViewController.swift
//  3D轮播图
//
//  Created by taoyi-two on 16/8/23.
//  Copyright © 2016年 fench. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, HF3DViewDelegate {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var pickView: UIPickerView!
    let animations = ["All:所有动画随机", "fade:淡入淡出", "moveIn:移入新视图", "reveal:移开旧视图", "cube:立体翻转", "suckEffect:布片抽走", "rippleEffect:水滴", "pageCurl:翻页", "pageUnCurl:反向翻页", "cameraIrisHollowOpen:相机打开", "cameraIrisHollowClose:相机关闭", "oglFlip:翻转"]
    var adView : HF3D_ADView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickView.delegate = self
        pickView.dataSource = self
        
        var pictures : [UIImage]
        pictures = [UIImage]()
        for i in 0...5 {
            let image = UIImage(named: String(i))
            pictures.append(image!)
        }
    // 使用ADView
        adView = HF3D_ADView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 120), pictures:pictures, timeInterval: 3.0)
        // 可以定制动画
//        var options:HF3DAnimationOptions = [HF3DAnimationOptions.Fade, HF3DAnimationOptions.RippleEffect]
//        adView?.animationOptins = options
        
        adView?.delegate = self
        adView?.animationOptins = HF3DAnimationOptions.All
        if segment.selectedSegmentIndex == 1 {
            adView?.subType = kCATransitionFromLeft
        } else {
            adView?.subType = kCATransitionFromRight
        }
        
        self.view.addSubview(adView!)
    }
    @IBAction func sliderSwipe(sender: UISlider) {
        adView?.timeInterval = NSTimeInterval(sender.value)
    }
    @IBAction func segmentClick(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            adView?.subType = kCATransitionFromLeft
            break
        case 1:
            adView?.subType = kCATransitionFromRight
            break
        case 2:
            adView?.subType = kCATransitionFromTop
            break
        case 3:
            adView?.subType = kCATransitionFromBottom
            break
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return animations[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch String(1<<row, radix:2).characters.count - 1 {
        case 0:
            adView?.animationOptins = HF3DAnimationOptions.All
            break
        case 1:
            adView?.animationOptins = HF3DAnimationOptions.Fade
            break
        case 2:
            adView?.animationOptins = HF3DAnimationOptions.MoveIn
            break
        case 3:
            adView?.animationOptins = HF3DAnimationOptions.Reveal
            break
        case 4:
            adView?.animationOptins = HF3DAnimationOptions.Cube
            break
        case 5:
            adView?.animationOptins = HF3DAnimationOptions.SuckEffect
            break
        case 6:
            adView?.animationOptins = HF3DAnimationOptions.RippleEffect
            break
        case 7:
            adView?.animationOptins = HF3DAnimationOptions.PageCurl
            break
        case 8:
            adView?.animationOptins = HF3DAnimationOptions.PageUnCurl
            break
        case 9:
            adView?.animationOptins = HF3DAnimationOptions.CameraIrisHollowOpen
            break
        case 10:
            adView?.animationOptins = HF3DAnimationOptions.CameraIrisHollowClose
            break
        case 11:
            adView?.animationOptins = HF3DAnimationOptions.oglFlip
            break
        default:
            break
        }
    }
    
    func imageDidClick(adView: HF3D_ADView, index: Int) {
        print("点击了第\(index)个图片")
    }
    
}

