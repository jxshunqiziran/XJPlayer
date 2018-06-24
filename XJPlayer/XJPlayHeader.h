//
//  XJPlayHeader.h
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/2.
//  Copyright © 2018年 XJ. All rights reserved.
//

#ifndef XJPlayHeader_h
#define XJPlayHeader_h

#define XJScreenWidth  [UIScreen mainScreen].bounds.size.width

#define XJScreenHeight [UIScreen mainScreen].bounds.size.height

#define WeakSelf(weakSelf) __weak typeof(self)  weakSelf = self;

#define MAXHiddenTime 5


/***************获取图片资源***********/

#define imagePath [[NSBundle mainBundle]pathForResource:@"XJPlayerPic" ofType:@"bundle"]

#define XJGetImage(name)  [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:name]]



/****KVO***/
//#import "Masonry.h"
#import <Masonry/Masonry.h>

#endif /* XJPlayHeader_h */
