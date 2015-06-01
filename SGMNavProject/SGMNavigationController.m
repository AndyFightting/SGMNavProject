//
//  SGMNavigationController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "SGMNavigationController.h"
#import <QuartzCore/QuartzCore.h>//截屏要用

@interface SGMNavigationController ()

@end

@implementation SGMNavigationController{

    CGPoint startPoint;//触摸开始坐标
    
    UIView* shotViewContainerView;//截屏view的容器view
    UIImageView* lastScreenShotView;//最近的一次截屏图片
    UIView* blackMask;//黑色半透明遮罩
    
    NSMutableArray* screenShotsArray;
    
}

@synthesize isSupportPenGesture;
@synthesize animationType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    screenShotsArray = [[NSMutableArray alloc]init];
    //拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
}
//手势处理
-(void)handlePanGesture:(UIGestureRecognizer*)sender{
    
    //如果是顶级viewcontroller，活动动画关闭，结束
    if (self.viewControllers.count <= 1||!isSupportPenGesture){
         return;
    }
    
    CGPoint translation=[sender locationInView:WINDOW];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        //开始坐标
        startPoint = translation;
        if (!shotViewContainerView)
        {
            //添加背景
            CGRect frame = self.view.frame;
            shotViewContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            shotViewContainerView.backgroundColor = [UIColor blackColor];
            //把backgroundView插入到Window视图上，并below低于self.view层
            [WINDOW insertSubview:shotViewContainerView belowSubview:self.view];
            
            //在backgroundView添加黑色的面罩
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [shotViewContainerView addSubview:blackMask];
        }
        shotViewContainerView.hidden = NO;
        
        if (lastScreenShotView){
         [lastScreenShotView removeFromSuperview];
        }
           
        //数组中最后截图
        UIImage *lastScreenShot = [screenShotsArray lastObject];
        //并把截图插入到backgroundView上，并黑色的背景下面
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [shotViewContainerView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (sender.state == UIGestureRecognizerStateChanged){
        [self moveViewWithX:translation.x - startPoint.x];
    }else if(sender.state == UIGestureRecognizerStateEnded){
        
        //如果结束坐标大于开始坐标50像素就动画效果移动
        if (translation.x - startPoint.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:WINDOW_WIDTH];
            } completion:^(BOOL finished) {
                //返回上一层
                [self popViewControllerAnimated:NO];
                //并且还原坐标
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                //背景隐藏
                shotViewContainerView.hidden = YES;
                
            }];
            
        }else{
            //不大于50时就移动原位
            [UIView animateWithDuration:0.3 animations:^{
                //动画效果
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                //背景隐藏
                shotViewContainerView.hidden = YES;
            }];
        }
    }else{
        NSLog(@"失败");
    }
    

}
- (void)moveViewWithX:(float)x
{
    //这个必须加 否则可以往左边移动
    x = x>WINDOW_WIDTH?WINDOW_WIDTH:x;
    x = x<0?0:x;
    
    float alpha = 0.5 - (x/WINDOW_WIDTH)*0.5;//透明值
    blackMask.alpha = alpha;

    CGRect frame = self.view.frame;
    CGRect frameSyn = self.view.frame;
    CGRect frameAsyn = self.view.frame;
    float scale;
    
    frame.origin.x = x;
    self.view.frame = frame;    

    switch (animationType) {
        case SGMNavigationAnimationScale://尺寸动画
            scale = (x/WINDOW_WIDTH)*0.05+0.95;//缩放大小
            lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
            break;
        case SGMNavigationAnimationSynMove://同步移动
            frameSyn.origin.x = x-WINDOW_WIDTH;
            lastScreenShotView.frame = frameSyn;
            break;
        case SGMNavigationAnimationAsynMove://差异化移动
            frameAsyn.origin.x = x/2.5-WINDOW_WIDTH/2.5;
            lastScreenShotView.frame = frameAsyn;
            break;
        default:  //背景静止 默认
            //什么都不做
            break;
    }
}
//实现截屏
- (UIImage *)ViewRenderImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0); //
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenShotImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenShotImg;
}

#pragma Navigation 覆盖方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //图像数组中存放一个当前的界面截屏，然后再push
    [screenShotsArray addObject:[self ViewRenderImage]];
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //移除最后一个截屏
    [screenShotsArray removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
