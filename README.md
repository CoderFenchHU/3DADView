# 3DADView
用swift写的一个小玩意。
iOS上一个实用的3D动画广告视图 
  可定制动画类型，实用简单。
  
  adView = HF3D_ADView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 120), pictures: pictureArr, timeInterval: 3.0)
  // 设置动画类型 可设置多项 随机播放
  adView?.animationOptins = HF3DAnimationOptions.All
  //        var options:HF3DAnimationOptions = [HF3DAnimationOptions.Fade, HF3DAnimationOptions.RippleEffect]
  //        adView?.animationOptins = options
  // 直接加入控制器的视图即可
  self.view.addSubview(adView!)
