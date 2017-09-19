//
//  ViewController.h
//  momiaoya
//
//  Created by zhuxu on 2017/9/8.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITabBarController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITabBarDelegate>

+ (nullable UIImage *)imageResize:(nullable UIImage *)image rect:(CGRect)rect;
@end

