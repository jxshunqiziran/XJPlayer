//
//  XJControlView.h
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/2.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJPlayHeader.h"
#import "UIView+Control.h"


@protocol XJControlDelegate<NSObject>

- (void) xjControlfullScreenClick;

- (void) xjConrolPlayActionClick;

- (void) xjSeekToTimeActionClick:(UISlider*)slider;

@end

@interface XJControlView : UIView

@property (nonatomic,assign) id <XJControlDelegate> delegate;

@end
