//
//  MuDrawerController.m
//  MuVR
//
//  Created by 思久科技 on 2017/2/10.
//  Copyright © 2017年 VR-MU. All rights reserved.
//

#import "MuDrawerController.h"
#define ViewWidth ([UIScreen mainScreen].bounds.size.width)

@interface MuDrawerController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@end

@implementation MuDrawerController

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController MenuViewController:(UIViewController *)menuViewController{
    self = [super init];
    if (self) {
        self.mainVC = mainViewController;
        self.menuVC = menuViewController;
        
        //初始化全局变量
        self.sideWidth = 95.0f;
        self.handlePanWidth = 60.0f;//*ViewWidth/320;        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加左边的菜单视图控制器
    if (self.menuVC) {
        [self addChildViewController:self.menuVC];
        self.menuVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-self.sideWidth, CGRectGetHeight(self.view.frame));
        [self.view addSubview:self.menuVC.view];
        [self.menuVC didMoveToParentViewController:self];
        
        // 菜单栏层上添加阴影层
        _shadowView = [[UIView alloc]initWithFrame:self.menuVC.view.bounds];
        [_shadowView setBackgroundColor:[UIColor blackColor]];
        [self.menuVC.view addSubview:_shadowView];
    }
    // 添加主视图控制器
    if (self.mainVC) {
        [self addChildViewController:self.mainVC];
        [self.view addSubview:self.mainVC.view];
        [self.mainVC didMoveToParentViewController:self];        
    }
    // 添加手势显示隐藏菜单栏
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    
    self.control = [[UIControl alloc]init];
    self.control.frame = CGRectMake(ViewWidth - self.sideWidth, 0, self.sideWidth, CGRectGetHeight(self.view.frame));
    [self.control addTarget:self action:@selector(hiddenLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.control];
    //当mainVC是 UITabBarController
    [self.mainVC addObserver: self forKeyPath: @"selectedViewController" options: NSKeyValueObservingOptionNew context: nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    [self addDelete:]
//    UINavigationController * nc = object;
//    nc.topViewController.view;
//    [self addDelete:nc.visibleViewController.view];
}

- (void)addDelete:(UIView*)view {
    for (int i = 0; i < view.subviews.count; i++) {
        UIView * subview = [view.subviews objectAtIndex:i];
        if ([subview isKindOfClass: [UIScrollView class]]) {
            UIScrollView * scrollview = (UIScrollView*)subview;
            scrollview.delegate = self;
        }else {
            [self addDelete:subview];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self addDelete:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.mainVC.view.frame.origin.x > 0) {
        // 显示菜单栏
        _isShow = YES;
        _shadowView.alpha = 0.0;
        self.control.hidden = NO;
    }else{
        _isShow = NO;
        _shadowView.alpha = 0.8;
        self.control.hidden = YES;
    }    
}
#pragma mark - 主视图阴影效果
- (void)setShowsShadow:(BOOL)show {
    
    // 主页层上添加边阴影
    self.mainVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainVC.view.layer.shadowOffset = CGSizeMake(-5, 1);            //阴影偏移量
    self.mainVC.view.layer.shadowOpacity = 0.5;                         //阴影的透明度
    self.mainVC.view.layer.shadowRadius = 5.0;                          //阴影的圆角
}

#pragma mark - 监听手势动作
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    if ([self.mainVC isKindOfClass:[UINavigationController class]]) {
        if (self.mainVC.childViewControllers.count > 1) {
            return;
        }
    }else if ([self.mainVC isKindOfClass:[UITabBarController class]]){
        UITabBarController * tbvc = (UITabBarController*)self.mainVC;
        UIViewController * vc = tbvc.viewControllers[tbvc.selectedIndex];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            if (vc.childViewControllers.count > 1) {
                return;
            }
        }
    }
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if ((self.mainVC.view.frame.origin.x <= 0 && translation.x<0) || (self.mainVC.view.frame.origin.x >= ViewWidth-self.sideWidth && translation.x>0)) {
        if(self.mainVC.view.frame.origin.x <= 0){
            _isShow = NO;
            [self showOrHiddenLeftView:NO];
        }else{
            _isShow = YES;
            [self showOrHiddenLeftView:NO];
        }
        return;
    }
    if(self.mainVC.view.frame.origin.x < 0){
        CGRect frame = self.mainVC.view.frame;
        frame.origin.x = 0;
        self.mainVC.view.frame = frame;
        return;
    }else if(self.mainVC.view.frame.origin.x > ViewWidth-self.sideWidth){
        CGRect frame = self.mainVC.view.frame;
        frame.origin.x = ViewWidth-self.sideWidth;
        self.mainVC.view.frame = frame;
        return;
    }
    self.mainVC.view.center = CGPointMake(self.mainVC.view.center.x + translation.x, self.mainVC.view.center.y);
    
    float alpha = 0.8 - ((self.mainVC.view.frame.origin.x)/(ViewWidth-self.sideWidth));
    _shadowView.alpha = alpha;
    [recognizer setTranslation:CGPointZero inView:self.mainVC.view];
    //滑动停止
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (ViewWidth-self.sideWidth-self.handlePanWidth<self.handlePanWidth) {
            self.handlePanWidth = (ViewWidth-self.sideWidth)/2.0;
        }
        if (self.mainVC.view.frame.origin.x<self.handlePanWidth) {
            _isShow = NO;
            [self showOrHiddenLeftView:NO];
            
        }else if (self.mainVC.view.frame.origin.x>ViewWidth-self.sideWidth-self.handlePanWidth) {
            _isShow = YES;
            [self showOrHiddenLeftView:NO];
            
        }else{
            if (_isShow==YES) {
                _isShow = NO;
            }else{
                _isShow = YES;
            }
            [self showOrHiddenLeftView:NO];
        }
    }
}

- (void)hiddenLeftView {
    [self showOrHiddenLeftView:YES];
}

#pragma mark - 显示隐藏菜单栏
- (void)showOrHiddenLeftView:(BOOL)isExternalCall {
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.mainVC.view.frame;
        if (isExternalCall == YES) {//如果是点击按键显示隐藏 则取反
            if (_isShow == YES) {
                // 隐藏
                frame.origin.x = 0.0f;
                _isShow = NO;
                _shadowView.alpha = 1;
                self.control.hidden = YES;
            }else{
                // 显示
                frame.origin.x = ViewWidth-self.sideWidth;
                _isShow =YES;
                _shadowView.alpha = 0;
                self.control.hidden = NO;
            }
        }else{//如果是滑动显示隐藏 则根据实际情况
            if (_isShow) {
                // 显示
                frame.origin.x = ViewWidth-self.sideWidth;
                _shadowView.alpha = 0;
                self.control.hidden = NO;
            }else{
                // 隐藏
                frame.origin.x = 0.0f;
                _shadowView.alpha = 1;
                self.control.hidden = YES;
            }
        }
        self.mainVC.view.frame = frame;
    }];
}

- (void)dealloc {
    _shadowView = nil;
    _sideWidth = 0;
    _handlePanWidth = 0;
    _mainVC = nil;
    _menuVC = nil;
    [self.view removeObserver:self forKeyPath:@"frame"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"testset");
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"tsetes");
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
//    NSLog(@"%@",NSStringFromCGPoint(translation));
//    NSLog(@"%f",scrollView.contentOffset.x);
    if ( scrollView.contentOffset.x < 10 && translation.x > 10 && fabs(translation.y) < 20) {//预留10，避免错误滚动
        [self showOrHiddenLeftView:YES];
    }
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
////    if ([viewController isKindOfClass:[UINavigationController class]]) {
////        UINavigationController * vc = (UINavigationController*)viewController;
////        [vc.topViewController loadView];
////        [self addDelete:vc.topViewController.view];
////    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

