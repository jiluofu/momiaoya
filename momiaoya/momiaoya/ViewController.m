//
//  ViewController.m
//  momiaoya
//
//  Created by zhuxu on 2017/9/8.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import "ViewController.h"
#import "MMPhotoCell.h"
#import "MMPhotoEditViewController.h"
#import "MMTabViewController.h"

#define cellidentifier @"PHOTO_CELL"

@interface ViewController ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property CGFloat frameWidth;
@property CGFloat frameHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"###test momiaoya");
    
    self.title = @"自己制作不被APP图标遮挡の墙纸";
    CGRect rect = [UIScreen mainScreen].bounds;
    self.frameWidth = rect.size.width - 10;
    self.frameHeight = (rect.size.width - 10) * 2 / 3;
    
    
    
    
    UIViewController *vc1=[[UIViewController alloc] init];
//    vc1.view.backgroundColor = [UIColor orangeColor];
    vc1.tabBarItem.title = @"test";
    vc1.tabBarItem.badgeValue = @"22";
    
    self.viewControllers = @[vc1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.translucent = NO;
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height - 49;
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:0.5];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    
    
    [self.collectionView registerClass:[MMPhotoCell class] forCellWithReuseIdentifier:@"PHOTO_CELL"];
    
    
    
    
    
    [self.view addSubview:self.collectionView];
    
    
    //配置UICollectionViewFlowLayout属性
    
    
    //每个itemsize的大小
    layout.itemSize = CGSizeMake(self.frameWidth / 2, self.frameHeight / 2);
    //行与行的最小间距
    layout.minimumLineSpacing = 5;
    
    //每行的item与item之间最小间隔（如果）
    layout.minimumInteritemSpacing = 0;
    //每个section的头部大小
    //    layout.headerReferenceSize = CGSizeMake(44, 44);
    //每个section距离上方和下方20，左方和右方10
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 0);
    //垂直滚动(水平滚动设置UICollectionViewScrollDirectionHorizontal)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

// 1个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个section中有8个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  13;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
//    cell.label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    
//    NSURL *url = [NSURL URLWithString: @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png"];
//    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//    cell.imageView = [[UIImageView alloc]initWithImage:image];
    
//    cell.imageView.frame = cell.bounds;
//    [cell.contentView addSubview:cell.imageView];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    
    
    NSString *name = [NSString stringWithFormat:@"%02zd", indexPath.row + 1];
    
    NSLog(@"###name:%@", name);
    
//    UIImage *image = [UIImage imageNamed:name];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];

    UIImage *newImage = [ViewController imageResize:image rect:rect];
    UIImageView *imageView =[[UIImageView alloc]initWithImage:newImage];
    
//    imageView.layer.borderWidth = 1.0f;
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    
    
    
    [cell.contentView addSubview:imageView];

   
    
    
    
    return cell;
}

+ (nullable UIImage *)imageResize:(nullable UIImage *)image rect:(CGRect)rect {
    

    CGSize size = CGSizeMake(rect.size.width - 10, (rect.size.width - 10) * 2 / 3);
    CGRect newRect = CGRectMake(0, 0, size.width / 2, size.height / 2);
    CGSize newSize = CGSizeMake(newRect.size.width - 10, (newRect.size.width - 10) * 2 / 3);
    if([[UIScreen mainScreen] scale] == 2.0){      // @2x
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    }
    else if([[UIScreen mainScreen] scale] == 3.0){ // @3x ( iPhone 6plus 、iPhone 6s plus)
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 3.0);
    }
    else{
        UIGraphicsBeginImageContext(newSize);
    }
    
    [image drawInRect:newRect];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"####didSelectItemAtIndexPath:%ld", indexPath.row + 1);
    MMPhotoEditViewController *pe = [[MMPhotoEditViewController alloc] init];
    pe.photoFileName = [NSString stringWithFormat:@"%02zd", indexPath.row + 1];
    
    [self.navigationController pushViewController:pe animated:YES];
}

@end
