//
//  MuDrawerController.h
//  MuVR
//
//  Created by 思久科技 on 2017/2/10.
//  Copyright © 2017年 VR-MU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MuDrawerController : UIViewController<UIGestureRecognizerDelegate>{
    UIView *_shadowView;//菜单栏阴影效果层
    BOOL _isShow;//是否显示菜单栏
}

@property (strong, nonatomic) UIViewController *mainVC;//主视图控制器
@property (strong, nonatomic) UIViewController *menuVC;//菜单栏视图控制器

@property (nonatomic, assign) float sideWidth;//侧边保留主视图宽度
@property (nonatomic, assign) float handlePanWidth;//控制滑动宽度为多少，才时会切换

@property (strong, nonatomic) UIControl *control;

/**
 初始化视图控制器，传入主视图、菜单视图控制器

 @param mainViewController 主视图控制器
 @param menuViewController 菜单视图控制器
 @return 视图控制器
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController MenuViewController:(UIViewController *)menuViewController;
/*
 ***显示隐藏菜单栏，外部调用则isExternalCall:YES 本类调用则为:NO
 app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
 [app.sideBarVC showOrHiddenView:YES];
 */


/**
 主视图阴影效果

 @param show 是否显示阴影
 */
- (void)setShowsShadow:(BOOL)show;

/**
 显示或隐藏左视图

 @param isExternalCall 是否是外部调用，外部调用则isExternalCall:YES 本类调用则为:NO
 */
- (void)showOrHiddenLeftView:(BOOL)isExternalCall;

@end

@interface UIScrollView (MuDrawerController)

@end
