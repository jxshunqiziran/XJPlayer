//
//  XJControlView.m
//  XJPlayer
//
//  Created by 江鑫 on 2018/5/2.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "XJControlView.h"
#import <Foundation/Foundation.h>
#import "XJPlayHeader.h"

@interface XJControlView ()
{
    
    NSTimer * _timer;
    
}

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *currentTimelab;

@property (nonatomic, strong) UILabel *allTimelab;

@property (nonatomic, assign) NSInteger currentTime;

@end

@implementation XJControlView

- (instancetype) init
{
    
    self = [super init];
    
    if (self) {
        
        [self setupView];
        
        [self configRestartHiddenTimer];

        
    }
    
    return self;
    
    
}

- (void) setupView
{
    
    [self addSubview:self.fullScreenBtn];
    
    [self addSubview:self.playBtn];
    
    [self addSubview:self.currentTimelab];
    
    [self addSubview:self.allTimelab];
    
    [self addSubview:self.slider];
    
    [self addSubview:self.progressView];
    
}

#pragma mark  ------   懒加载 ----------


- (UIButton*) fullScreenBtn
{
    
    if (!_fullScreenBtn) {
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:XJGetImage(@"fullscreen") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goAllScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        _fullScreenBtn = btn;
        
    }
    return _fullScreenBtn;
    
}

- (UIButton*)playBtn
{
    
    if (!_playBtn) {
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:XJGetImage(@"pause") forState:UIControlStateNormal];
        [btn setBackgroundImage:XJGetImage(@"play")forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(pauseVideo:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn = btn;
        
    }
    return _playBtn;
    
}

- (UILabel*)currentTimelab
{
    if (!_currentTimelab) {
        
        UILabel*lab = [[UILabel alloc]init];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"00:00";
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:10];
        _currentTimelab = lab;
        
    }
    
    return _currentTimelab;
    
}

- (UILabel*)allTimelab
{
    if (!_allTimelab) {
        
        UILabel*lab = [[UILabel alloc]init];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"00:00";
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont systemFontOfSize:10];
        _allTimelab = lab;
        
    }
    
    return _allTimelab;
    
}

- (UIProgressView*)progressView
{
    
    if (!_progressView) {
        
        UIProgressView*progressView = [[UIProgressView alloc]init];
        //设置已经走过的进度的颜色:
        progressView.progressTintColor = [UIColor whiteColor];
        progressView.trackTintColor    = [UIColor clearColor];
        _progressView = progressView;
        
    }
    
    return _progressView;
    
}

- (UISlider*)slider
{
    
    if (!_slider) {
        
        UISlider*slider = [[UISlider alloc]init];
        [slider setThumbImage:XJGetImage(@"dot") forState:UIControlStateNormal];
        slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
        [slider addTarget:self action:@selector(seekSlider) forControlEvents:UIControlEventValueChanged];
        _slider = slider;
        
    }
    
    return _slider;
    
}


- (void) layoutSubviews
{
    
    [super layoutSubviews];
    
    __block typeof(self) weakSelf = self;
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.bottom.equalTo(weakSelf).with.offset(-12);
        
    }];
    
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.equalTo(weakSelf).with.offset(-12);
        
    }];
    
    
    [self.currentTimelab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.playBtn.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 30));
        make.bottom.equalTo(weakSelf).with.offset(-7);
        
    }];
    
    [self.allTimelab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.fullScreenBtn.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 30));
        make.bottom.equalTo(weakSelf).with.offset(-7);
        
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.allTimelab.mas_left).with.offset(-10);
        make.left.equalTo(weakSelf.currentTimelab.mas_right).with.offset(16);
        make.bottom.equalTo(weakSelf).with.offset(-21);
        
    }];
    
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.allTimelab.mas_left).with.offset(-10);
        make.left.equalTo(weakSelf.currentTimelab.mas_right).with.offset(10);
        make.bottom.equalTo(weakSelf).with.offset(-18);
        
    }];
    
}


#pragma mark  ------ action -----

- (void)pauseVideo:(UIButton*)btn
{
    
    [self configRestartHiddenTimer];
    
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xjConrolPlayActionClick)]) {
        
        [self.delegate xjConrolPlayActionClick];
        
    }
    
    
}

- (void) goAllScreen:(UIButton*)sender
{
    
    [self configRestartHiddenTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xjControlfullScreenClick)]) {
        
        [self.delegate xjControlfullScreenClick];
        
    }
    
}

- (void) seekSlider
{
    

    [self configRestartHiddenTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xjSeekToTimeActionClick:)]) {
        
        [self.delegate xjSeekToTimeActionClick:self.slider];
        
    }
    
    
}


- (void) xjConfigTotalTime:(CGFloat)totalTime;
{
    
    NSInteger alltime = (NSInteger)totalTime;
    
    self.allTimelab.text = [NSString stringWithFormat:@"%02ld:%02ld",alltime/60,alltime%60];
    
}


- (void) xjConfigCurrentTime:(CGFloat)currentTime;
{
    
    NSInteger nowtime = (NSInteger)currentTime;
    
    self.currentTimelab.text = [NSString stringWithFormat:@"%02ld:%02ld",nowtime/60,nowtime%60];

}

- (void) xjConfigSliderValue:(CGFloat)slidervalue;
{
    
    [self.slider setValue:slidervalue];
    
}

- (void) xjConfigloadProgress:(CGFloat)progress
{
    
    [self.progressView  setProgress:progress animated:YES];
    
}

- (void) willhidden
{
    
    self.currentTime-=1;
    
    if (self.currentTime == 0) {
        
        self.hidden = YES;
        [_timer invalidate];
        _timer = nil;
        
    }
    
    
}

- (void) configRestartHiddenTimer
{
    
    self.hidden = NO;
    
    self.currentTime = MAXHiddenTime;
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(willhidden) userInfo:nil repeats:YES];
        
    }
    
}



@end
