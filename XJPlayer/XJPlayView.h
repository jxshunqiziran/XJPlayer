//
//  XJPlayView.h
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/1.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XJPlayStatu){
    
    /**
     * The video is playback failed due to some problem.
     */
    XJPlayerStatuFailed,
    
    /**
     * The video is unknown error happened.
     */
    XJPlayerStatuUnknown,
    
    /**
     * The video is playing,but not finish.
     */
    XJPlayerStatuPlaying,
    
    /**
     * The video is stopped,so was not play now and redy to play.
     */
    XJPlayerStatuStopped,
    
    /**
     * The video is stopped,so was pause now and redy to play.
     */
    XJPlayerStatuPause,
    
};

@interface XJPlayView : UIView

@property (nonatomic, assign) BOOL isFullScreen;

/******播放的url地址******/
@property (nonatomic, copy) NSString *playUrl;

/******当前视频播放状态******/
@property (nonatomic, assign) XJPlayStatu playStatu;

- (XJPlayView*) initWithURl:(NSString*)url controlView:(UIView*)view frame:(CGRect)frame;

@end
