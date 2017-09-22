//
//  MMPhotoEditViewController.h
//  momiaoya
//
//  Created by zhuxu on 2017/9/15.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MMPhotoEditViewController : UIViewController <UIGestureRecognizerDelegate>
@property NSString *photoFileName;
@property NSInteger tag;
@property UIImage *localPhotoImage;
@end
