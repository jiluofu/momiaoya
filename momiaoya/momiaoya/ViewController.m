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

#define PHOTO_CELL @"PHOTO_CELL"
#define LOCAL_PHOTO_CELL @"LOCAL_PHOTO_CELL"
#define REFRESH_HEIGHT 50

@interface ViewController ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionView *collectionView1;
@property CGFloat frameWidth;
@property CGFloat frameHeight;
@property(nonatomic,strong)UINavigationController *nc1;
@property(nonatomic,strong)UINavigationController *nc2;
@property(nonatomic,strong)NSMutableArray *localPhotoArr;
@property(nonatomic,strong)PHFetchResult<PHAsset *> *assets;
@property(nonatomic,strong)UILabel *refreshLabel;
@property(nonatomic,strong)UILabel *moreLabel;
@property NSInteger num;
@property NSInteger tabTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"###test momiaoya");
    
    

    self.num = 10;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.frameWidth = rect.size.width - 10;
    self.frameHeight = (rect.size.width - 10) * 2 / 3;
    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEIGHT, rect.size.width, REFRESH_HEIGHT)];
    self.refreshLabel.backgroundColor = [UIColor redColor];
    self.refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.text = @"下拉刷新";
    
//    self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, REFRESH_HEIGHT, rect.size.width, REFRESH_HEIGHT)];
//    self.moreLabel.backgroundColor = [UIColor redColor];
//    self.moreLabel.font = [UIFont boldSystemFontOfSize:12.0];
//    self.moreLabel.textAlignment = NSTextAlignmentCenter;
//    self.moreLabel.text = @"上拉加载";
    
    
    rect.size.height = rect.size.height - 49;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.frameWidth / 2, self.frameHeight / 2);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.itemSize = CGSizeMake(self.frameWidth / 2, self.frameHeight / 2);
    layout1.minimumLineSpacing = 5;
    layout1.minimumInteritemSpacing = 0;
    layout1.sectionInset = UIEdgeInsetsMake(20, 10, 20, 0);
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;


    
    
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.navigationItem.title = @"自己制作不被APP图标遮挡の墙纸";
    vc1.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:0.5];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.tag = 0;
    
    
    
    
    [self.collectionView registerClass:[MMPhotoCell class] forCellWithReuseIdentifier:PHOTO_CELL];
    [vc1.view addSubview:self.collectionView];
    
    self.nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    [self.nc1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"Helvetica" size:18.0], NSFontAttributeName, nil]
                        forState:UIControlStateNormal];
    self.nc1.tabBarItem.title = @"精选";
    self.nc2.tabBarItem.tag = 0;
    self.nc1.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.navigationItem.title = @"本地相册";
    vc2.edgesForExtendedLayout = UIRectEdgeNone;
    self.collectionView1 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout1];
    self.collectionView1.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:0.5];
    
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView1.tag = 1;
    
    
    
    
    [self.collectionView1 registerClass:[MMPhotoCell class] forCellWithReuseIdentifier:LOCAL_PHOTO_CELL];
    [vc2.view addSubview:self.collectionView1];
    self.nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    [self.nc2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"Helvetica" size:18.0], NSFontAttributeName, nil]
                                       forState:UIControlStateNormal];
    self.nc2.tabBarItem.title = @"相册";
    self.nc2.tabBarItem.tag = 1;
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
    
//    if (collectionView.tag == 1) {
//
//        return [self.localPhotoArr count];
//
//    }
//    else if (collectionView.tag == 0) {
//
//        return 13;
//    }
    
    return self.num;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MMPhotoCell *cell = nil;
    
    
    if (collectionView.tag == 0) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTO_CELL forIndexPath:indexPath];
    }
    else if (collectionView.tag == 1) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:LOCAL_PHOTO_CELL forIndexPath:indexPath];
    }
    

    
//    cell.label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    
//    NSURL *url = [NSURL URLWithString: @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png"];
//    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//    cell.imageView = [[UIImageView alloc]initWithImage:image];
    
//    cell.imageView.frame = cell.bounds;
//    [cell.contentView addSubview:cell.imageView];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    
    
    NSString *name = [NSString stringWithFormat:@"%02zd", indexPath.item + 1];
    
    NSLog(@"###name:%@", name);
    
//    UIImage *image = [UIImage imageNamed:name];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (collectionView.tag == 1) {
        
        if (self.localPhotoArr[indexPath.item]) {
            
            image = self.localPhotoArr[indexPath.item];
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
    
    NSLog(@"###size:image-rect:%0.0f", image.size.width - rect.size.width);

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
        
        pe.photoFileName = [NSString stringWithFormat:@"%02zd", indexPath.item + 1];
        [self.nc1 pushViewController:pe animated:YES];
    }
    else if (collectionView.tag == 1) {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        PHAsset *asset = self.assets[indexPath.item];
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            pe.localPhotoImage = result;
            [self.nc2 pushViewController:pe animated:YES];
        }];
        
        
    }
    
    NSLog(@"####didSelectItemAtIndexPath:%ld", indexPath.item + 1);
}

// 下拉刷新
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -30 ) {
        [UIView animateWithDuration:1.0 animations:^{
            
            [scrollView addSubview:self.refreshLabel];
            
            [scrollView setContentInset:UIEdgeInsetsMake(REFRESH_HEIGHT, 0, 0, 0)];
            
        } completion:^(BOOL finished) {
            // 发起网络请求
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//            [self.collectionView reloadData];
        }];
    }
    else if (scrollView.contentOffset.y > 80 ) {
        
        
        
        [UIView animateWithDuration:1.0 animations:^{
            
            if (!self.moreLabel) {
                
                self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, scrollView.contentSize.height, self.refreshLabel.frame.size.width, REFRESH_HEIGHT)];
            }
            
//            self.moreLabel.backgroundColor = [UIColor redColor];
            self.moreLabel.font = [UIFont boldSystemFontOfSize:12.0];
            self.moreLabel.textAlignment = NSTextAlignmentCenter;
            self.moreLabel.text = @"上拉加载";
            NSLog(@"###height:%f", scrollView.frame.size.height);
            self.moreLabel.frame = CGRectMake(0, scrollView.contentSize.height, self.moreLabel.frame.size.width, self.moreLabel.frame.size.height);
            [scrollView addSubview:self.moreLabel];
            
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, REFRESH_HEIGHT, 0)];
           

           
            
        } completion:^(BOOL finished) {
            // 发起网络请求
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            NSLog(@"###count:%ld", [self.collectionView numberOfItemsInSection:0]);
            
            self.num ++;

            NSLog(@"###tag:%ld", self.tabTag);
            
            if (self.tabTag == 0) {
                
                [self.collectionView performBatchUpdates:^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:0] inSection:0];
                    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
                } completion:nil];
            }
            else {
                
                [self.collectionView1 performBatchUpdates:^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionView1 numberOfItemsInSection:0] inSection:0];
                    [self.collectionView1 insertItemsAtIndexPaths:@[indexPath]];
                } completion:nil];
            }
            

            
            

        }];
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//
//    NSLog(@"%f",scrollView.contentOffset.y);
//    NSLog(@"%f",scrollView.frame.size.height);
//    NSLog(@"%f",scrollView.contentSize.height);
//    /**
//     *  关键-->
//     *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
//     *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
//     *  个滚动视图的contentSize.height
//     */
//    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
//
//        NSLog(@"%d %s",__LINE__,__FUNCTION__);
//        [UIView commitAnimations];
//
//        [UIView animateWithDuration:1.0 animations:^{
//            //  frame发生的偏移量,距离底部往上提高60(可自行设定)
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
//        } completion:^(BOOL finished) {
//
//            /**
//             *  发起网络请求,请求加载更多数据
//             *  然后在数据请求回来的时候,将contentInset改为(0,0,0,0)
//             */
//        }];
//
//    }
//}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    self.tabTag = item.tag;
}


@end
