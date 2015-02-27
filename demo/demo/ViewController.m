//
//  ViewController.m
//  demo
//
//  Created by andy on 2/27/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import "ViewController.h"
#import "JXViewPager.h"

@interface ViewController ()<JXViewPagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [JXViewPager removeCache];
    [JXViewPager lanuchWithDelegate:self
                           resource:@"viewPager"
                        animateType:JXViewPagerAnimateZoom];
}

- (UIButton *)enterButton:(JXViewPager *)viewPager
{
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake(120, 100, 80, 50);
    enterButton.backgroundColor = [UIColor clearColor];
    [enterButton setTitle:@"马上登录" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    enterButton.layer.borderColor = [UIColor purpleColor].CGColor;
    enterButton.layer.borderWidth = 1.0;
    enterButton.layer.masksToBounds = YES;
    enterButton.layer.cornerRadius = 10;
    
    return enterButton;
}

@end
