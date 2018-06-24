//
//  UIView+Control.h
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/3.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Control)

- (void) xjConfigTotalTime:(CGFloat)totalTime;

- (void) xjConfigCurrentTime:(CGFloat)currentTime;

- (void) xjConfigSliderValue:(CGFloat)slidervalue;

- (void) xjConfigloadProgress:(CGFloat)progress;

- (void) configRestartHiddenTimer;

@end
