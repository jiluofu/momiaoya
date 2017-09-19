//
//  MMPhotoCell.m
//  momiaoya
//
//  Created by zhuxu on 2017/9/11.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import "MMPhotoCell.h"

@implementation MMPhotoCell : UICollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
//        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
//        self.label.textAlignment = NSTextAlignmentCenter;
//        self.label.textColor = [UIColor blackColor];
//        self.label.font = [UIFont boldSystemFontOfSize:15.0];
//        self.backgroundColor = [UIColor lightGrayColor];
//        self.layer.cornerRadius = 35.0;
//        self.layer.borderWidth = 1.0f;
        
        [self.contentView addSubview:self.label];
        
        
        
    }
    
    return self;
}

@end
