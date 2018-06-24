//
//  XJPlayView.m
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/1.
//  Copyright © 2018年 XJ. All rights reserved.
//

/*优化点:
 1,总时间计算太多次了;
 
 */

#import "XJPlayView.h"
#import "XJControlView.h"
#import "XJPlayHeader.h"
#import "UIView+Control.h"
#import <AVFoundation/AVFoundation.h>


@interface XJPlayView ()<XJControlDelegate>

@property (nonatomic, strong) UIView *playbgView;

@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end


static void * xjStatus = &xjStatus;

static void * xjTimeRange = &xjTimeRange;

@implementation XJPlayView

- (XJPlayView*) initWithURl:(NSString*)url controlView:(UIView*)view frame:(CGRect)frame;
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        self.playUrl = url;
        
        [self setupView];
        
        if (view) {

            self.controlView = view;

        }else{

            self.controlView = [[XJControlView alloc]init];
            
        }
        
        
    }
    
    
    return self;
    
    
}

- (void) setupView
{
    
    _playbgView = [[UIView alloc]initWithFrame:self.bounds];
    _playbgView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelf:)];
    [self addGestureRecognizer:tap];
    [self addSubview:_playbgView];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.playUrl]];
    
    _playItem = [AVPlayerItem playerItemWithAsset:asset];
    
    _player = [[AVPlayer alloc]initWithPlayerItem:_playItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_player play];
    
    [self addObserveOption];
    
}

- (void) setControlView:(UIView *)controlView
{
    
    if (!_controlView) {
        
        _controlView = controlView;
        
        if ([controlView isKindOfClass:[XJControlView class]]) {
            
            XJControlView*view= (XJControlView*)controlView;
            view.delegate = self;
            
        }

        [self.playbgView addSubview:controlView];

        [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            
        }];

    }
    
    
}

- (void) addObserveOption
{
    
    //1、KVO观察播放状态:
    [_playItem addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew context:xjStatus];
    
    //2、KVO观察缓冲进度:
    [_playItem addObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges)) options:NSKeyValueObservingOptionNew context:xjTimeRange];
    
    //3、监听设备方向:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //4、播放进度观察:
    WeakSelf(weakSelf);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(weakSelf.playItem.currentTime);
        
        CGFloat allTime = CMTimeGetSeconds(weakSelf.playItem.duration);
        
        //设置当前播放时间:
        [weakSelf.controlView xjConfigCurrentTime:currentTime];
        
        //设置播放进度:
        [weakSelf.controlView xjConfigSliderValue:currentTime/allTime];
        
    }];
    
}


/**
 * KVO观察回调:
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if (object == self.playItem) {
        
        if (context == xjStatus) {
            
            AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
            switch (status) {
                case AVPlayerStatusReadyToPlay:
                {
                    self.playStatu = XJPlayerStatuPlaying;
                    [self.playbgView.layer insertSublayer:self.playerLayer atIndex:0];
                    [self.controlView xjConfigTotalTime:CMTimeGetSeconds(self.playItem.duration)];
                }
                    break;
                    
                case AVPlayerStatusUnknown:
                {
                    self.playStatu = XJPlayerStatuUnknown;
                    [self.playbgView.layer addSublayer:self.playerLayer];
                }
                    break;
                 
                case AVPlayerStatusFailed:
                {
                    self.playStatu = XJPlayerStatuFailed;
                    [self.playbgView.layer addSublayer:self.playerLayer];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
        }
        
        //缓存进度:
        if (context == xjTimeRange) {
            
            CGFloat loadtime = [self getLoadTimeRange];
            CGFloat totalTime = CMTimeGetSeconds(self.playItem.duration);
            [self.controlView xjConfigloadProgress:loadtime/totalTime];
            
        }
        
    }
    
    
}

/**
 获取缓冲的时间:
 CMTimeRange的结构体就 start和duration,而且是CMTime类型,那么我们将它们转化成时间后相加就是缓存的时间了;
 */
- (NSTimeInterval)getLoadTimeRange
{
    
    NSArray *timeRanges = [[self.player currentItem]loadedTimeRanges];
    CMTimeRange range = [timeRanges.firstObject CMTimeRangeValue];
    CGFloat start = CMTimeGetSeconds(range.start);
    CGFloat duration = CMTimeGetSeconds(range.duration);
    NSTimeInterval result = start+duration;
    return result;
    
}

- (void) layoutSubviews
{
    
    [super layoutSubviews];
    
    self.playerLayer.frame = self.playbgView.bounds;
    
}

#pragma mark  ----- XJControlDelegate ----


/**
 点击全屏键:
 */
- (void) xjControlfullScreenClick
{

    [self configFullScreen:UIInterfaceOrientationLandscapeRight];
    
}


/**
 点击播放暂停键:
 */
- (void) xjConrolPlayActionClick
{
    
    if (self.playStatu == XJPlayerStatuPlaying) {
        
        [self.player pause];
        self.playStatu = XJPlayerStatuPause;
        
    }else{
        
        [self.player play];
        self.playStatu = XJPlayerStatuPlaying;
    }
    
    
}


/**
 拖动进度条:

 @param slider slider
 */
- (void) xjSeekToTimeActionClick:(UISlider *)slider
{
    
    CGFloat totalTime = CMTimeGetSeconds(self.playItem.duration);
    
    CMTime seekTime = CMTimeMake(slider.value*totalTime, 1);
    
    [self.player pause];
    self.playStatu = XJPlayerStatuPause;
    
    WeakSelf(weakSelf);
    
    [self.player seekToTime:seekTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
        
        [weakSelf.player play];
        weakSelf.playStatu = XJPlayerStatuPlaying;
        
    }];
    
    
}

#pragma mark   ------ 屏幕旋转 --------

/**
 旋转屏幕

 @param orientation 需要旋转的方向;
 */
- (void) configFullScreen:(UIInterfaceOrientation)orientation
{
    
    if (!self.isFullScreen) {
        
        [self.playbgView removeFromSuperview];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        [window addSubview:self.playbgView];
        
        [self.playbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(XJScreenHeight);
            make.height.mas_equalTo(XJScreenWidth);
            make.center.equalTo(window);
            
        }];
        
        CGFloat angle ;
        
        if (orientation == UIInterfaceOrientationLandscapeRight) {
            angle = M_PI_2;
        }else{
            angle = -M_PI_2;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playbgView.transform = CGAffineTransformMakeRotation(angle);
            
        }];
        
        self.isFullScreen = YES;
        
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        
        
    }else{
        
        [self.playbgView removeFromSuperview];
        
        [self addSubview:self.playbgView];
        
        [self.playbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playbgView.transform = CGAffineTransformIdentity;
            
        }];
        
        self.isFullScreen = NO;
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        
    }
    
    
}


/**
 屏幕方向发生改变:
 */
- (void) deviceOrientationChanged
{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            
            if (self.isFullScreen) {
                
                [self configFullScreen:interfaceOrientation];
            
            }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
            
            if (!self.isFullScreen) {
                
                [self configFullScreen:interfaceOrientation];
               
            }
            
            break;
        case UIInterfaceOrientationLandscapeRight:
            
            if (!self.isFullScreen) {
                
                [self configFullScreen:interfaceOrientation];
                
            }
            
            break;
        default:
            break;
    }
    
}


#pragma -------- private Method --------

- (void) showSelf:(UIGestureRecognizer*)tap
{
    
    [self.controlView configRestartHiddenTimer];
    
}

@end
