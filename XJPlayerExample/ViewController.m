//
//  ViewController.m
//  XJPlayerExample
//
//  Created by 江鑫 on 2018/5/3.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "ViewController.h"
#import "XJPlayView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
{
    XJPlayView*player;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    player = [[XJPlayView alloc]initWithURl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" controlView:nil frame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    player.backgroundColor = [UIColor redColor];
    [self.view addSubview:player];
}


/* OC */
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
