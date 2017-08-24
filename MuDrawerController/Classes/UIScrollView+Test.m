//
//  UIScrollView+Test.m
//  test
//
//  Created by BmMac on 2017/8/23.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "UIScrollView+Test.h"
#import <objc/runtime.h>

//@implementation NSObject (Test)
//
//+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
//{
//    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
//}
//
//+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
//{
//    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
//}
//
//@end

@implementation UIScrollView (Test)


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIScrollView * sv = (id)gestureRecognizer.view;
        NSLog(@"%f",sv.contentOffset.x);
        if (sv.contentOffset.x <= 0 ) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


//+ (void)load
//{
//    NSLog(@"s");
//    [self exchangeInstanceMethod1:@selector(touchesBegan:withEvent:) method2:@selector(mj_touchesBegan:withEvent:)];
//}
//
//- (void)mj_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    UITouch * touch = [touches.allObjects objectAtIndex:0];
////    CGPoint point1 = [touch locationInView:touch.view];
////    NSLog(@"%@",NSStringFromCGPoint(point1));
////    NSLog(@"%@",NSStringFromCGPoint(point2));
////    NSLog(@"%@",NSStringFromCGRect(touch.view.frame));
////    NSLog(@"s");
//}
//- (BOOL)mj_touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view
//{
//    [self mj_touchesShouldBegin:touches withEvent:event inContentView:view];
//    NSLog(@"s");
//    return YES;
//}

@end
