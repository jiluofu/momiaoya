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


#import <Photos/Photos.h>

#define cellidentifier @"PHOTO_CELL"
#define cellidentifierlocal @"LOCAL_PHOTO_CELL"

@interface ViewController ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionView *collectionView1;
@property CGFloat frameWidth;
@property CGFloat frameHeight;
@property(nonatomic,strong)UINavigationController *nc1;
@property(nonatomic,strong)UINavigationController *nc2;
@property(nonatomic,strong)NSMutableArray *localPhotoArr;
@property(nonatomic,strong)PHFetchResult<PHAsset *> *assets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"###test momiaoya");
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.frameWidth = rect.size.width - 10;
    self.frameHeight = (rect.size.width - 10) * 2 / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    rect.size.height = rect.size.height - 49;
    
    
    
    
    
    
//    [self.view addSubview:self.collectionView];
    
    
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

    
    
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.navigationItem.title = @"自己制作不被APP图标遮挡の墙纸";
    vc1.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:0.5];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.tag = 0;
    
    
    
    
    [self.collectionView registerClass:[MMPhotoCell class] forCellWithReuseIdentifier:@"PHOTO_CELL"];
    [vc1.view addSubview:self.collectionView];
    
    self.nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    [self.nc1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"Helvetica" size:18.0], NSFontAttributeName, nil]
                        forState:UIControlStateNormal];
    self.nc1.tabBarItem.title = @"精选";
    self.nc1.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.navigationItem.title = @"本地相册";
    vc2.edgesForExtendedLayout = UIRectEdgeNone;
    self.collectionView1 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView1.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:0.5];
    
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView1.tag = 1;
    
    
    
    
    [self.collectionView1 registerClass:[MMPhotoCell class] forCellWithReuseIdentifier:@"PHOTO_CELL"];
    [vc2.view addSubview:self.collectionView1];
    self.nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    [self.nc2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"Helvetica" size:18.0], NSFontAttributeName, nil]
                                       forState:UIControlStateNormal];
    self.nc2.tabBarItem.title = @"相册";
    self.nc2.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    
    self.viewControllers = @[self.nc1, self.nc2];
    
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    
    
    
    
    
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    self.localPhotoArr = [[NSMutableArray alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;

    // 获得某个相簿中的所有PHAsset对象
    self.assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    for (PHAsset *asset in self.assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;

        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            [self.localPhotoArr addObject:result];
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
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
    if (collectionView.tag == 1) {
        
        if (self.localPhotoArr[indexPath.row]) {
            
            image = self.localPhotoArr[indexPath.row];
        }
    }

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
    
    MMPhotoEditViewController *pe = [[MMPhotoEditViewController alloc] init];
    
    pe.tag = collectionView.tag;
    
    
    if (collectionView.tag == 0) {
        
        pe.photoFileName = [NSString stringWithFormat:@"%02zd", indexPath.row + 1];
        [self.nc1 pushViewController:pe animated:YES];
    }
    else if (collectionView.tag == 1) {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        PHAsset *asset = self.assets[indexPath.row];
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            pe.localPhotoImage = result;
            [self.nc2 pushViewController:pe animated:YES];
        }];
        
        
    }
    
    NSLog(@"####didSelectItemAtIndexPath:%ld", indexPath.row + 1);
}

@end
