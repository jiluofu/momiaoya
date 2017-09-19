//
//  MMPhotoEditViewController.m
//  momiaoya
//
//  Created by zhuxu on 2017/9/15.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import "MMPhotoEditViewController.h"

@interface MMPhotoEditViewController ()
@property UIImageView *imageView;
@end

@implementation MMPhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"### photo edit");
    self.title = @"手动缩放调整后，单击图片生成墙纸";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.photoFileName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
//    image = [MMPhotoEditViewController imageResize:image];
    
    self.imageView = [[UIImageView alloc]initWithImage:image];
    [self.imageView setUserInteractionEnabled:YES];
//    imageView.clipsToBounds  = YES;
//    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    imageView.contentMode =  UIViewContentModeScaleAspectFill;
//    self.imageView.contentMode =  UIViewContentModeLeft;
//    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 0.5, 0.5);
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [pinchGestureRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    [tapGestureRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
//    self.imageView.transform = CGAffineTransformMakeScale(.5, .5);
//    self.imageView.center = CGPointMake(0, 10);
    [self setPos];
    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//
//    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);

    
    
    
    [self.view addSubview:self.imageView];
    [self msgIntro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (nullable UIImage *)imageResize:(nullable UIImage *)image {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CGSize size = CGSizeMake(rect.size.width - 10, (rect.size.width - 10) * 2 / 3);
    CGRect newRect = CGRectMake(0, 0, size.width, size.height);
//    CGSize newSize = CGSizeMake(newRect.size.width - 10, (newRect.size.width - 10) * 2 / 3);
    if([[UIScreen mainScreen] scale] == 2.0){      // @2x
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }
    else if([[UIScreen mainScreen] scale] == 3.0){ // @3x ( iPhone 6plus 、iPhone 6s plus)
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }
    else{
        UIGraphicsBeginImageContext(size);
    }
    
    [image drawInRect:newRect];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return newImage;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];

    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y)];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

- (void)tapGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"### tap");
    [self saveWall];
}

- (void)setCenter {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.imageView.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
}

- (void)setPos {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    
    self.imageView.transform = CGAffineTransformMakeScale(rect.size.width / self.imageView.frame.size.width, rect.size.width / self.imageView.frame.size.width);
    self.imageView.center = CGPointMake(rect.size.width / 2, rect.size.height - (self.imageView.frame.size.height * rect.size.width / self.imageView.frame.size.width / 1.2));
    NSLog(@"###width:%f", rect.size.width);
}

- (void) saveWall {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前画面保存为墙纸？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil);
        [self msgSaved];
    }];
    
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    

    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
}

- (void) msgSaved {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存本地相册成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action= [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    // 2秒后执行
//    [self performSelector:@selector(dimissAlert:)withObject:alert afterDelay:2.0];
    
}

- (void) msgIntro {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手动缩放调整后，单击图片生成墙纸" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action= [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
//    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    // 2秒后执行
    [self performSelector:@selector(msgIntroDismiss:)withObject:alert afterDelay:4.0];
    
}

- (void) msgIntroDismiss:(UIAlertController *)alert {
    
    if(alert){
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
