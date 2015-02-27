//
//  JXViewPager.m
//  demo
//
//  Created by andy on 2/27/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import "JXViewPager.h"
#import "JXBaseAnimate.h"

#define JX_FIRST_LOGIN_KEY @"JX_FIRST_LOGIN_KEY"

@interface JXViewPager ()<UIScrollViewDelegate>
{
    // 启动Window
    UIWindow *_launchWindow;
    
    // 滚动视图
    UIScrollView *_scrollView;

    // 缓存图片
    NSMutableArray *_imageArray;

    // 动画
    JXBaseAnimate *_launchAnimate;
}

/**
 *  代理
 */
@property (nonatomic, weak) id<JXViewPagerDelegate> delegate;

@end

@implementation JXViewPager

- (instancetype)init
{
    if (self = [super init]) {
        // 缓存图片
        _imageArray = [NSMutableArray array];
        
        // 启动窗口
        _launchWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_launchWindow makeKeyAndVisible];
        
        // 滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:_launchWindow.bounds];
        _scrollView.hidden = YES;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [_launchWindow addSubview:_scrollView];
    }
    return self;
}

/// 单例
+ (instancetype)shareInstance
{
    static JXViewPager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/**
 *  加载图片
 *
 *  @param delegate     代理
 *  @param resource     资源文件名、( plist )
 *  @param animateType  动画类型
 */
+ (void)lanuchWithDelegate:(id<JXViewPagerDelegate>)delegate
                  resource:(NSString *)resource
               animateType:(JXViewPagerAnimateType)animateType
{
    // 如果用户已经开启过动画、跳过动画
    if ([[NSUserDefaults standardUserDefaults] boolForKey:JX_FIRST_LOGIN_KEY]) {
        return;
    }
    
    [[JXViewPager shareInstance] lanuchWithDelegate:delegate
                                           resource:resource
                                        animateType:animateType];
}

/**
 *  加载图片
 */
- (void)lanuchWithDelegate:(id<JXViewPagerDelegate>)delegate
                  resource:(NSString *)resource
               animateType:(JXViewPagerAnimateType)animateType
{
    self.delegate = delegate;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:resource
                                                     ofType:@"plist"];
    NSArray *imageArray = [NSArray arrayWithContentsOfFile:path];
    
    if (!imageArray && imageArray.count == 0) {
        return;
    }

    _scrollView.hidden = NO;
    
    // 修正滚动视图宽度
    CGSize s = CGSizeMake(CGRectGetWidth(_scrollView.frame) * imageArray.count,
                          CGRectGetHeight(_scrollView.frame));
    _scrollView.contentSize = s;
    
    // 清除缓存
    if (_imageArray.count > 0)
        [_imageArray removeAllObjects];
    
    // 创建图片
    int i = 0;
    CGRect frame = _scrollView.frame;
    for (NSString *imageName in imageArray) {
        
        if (i++ != 0)
            frame.origin.x += CGRectGetWidth(frame);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        
        [_imageArray addObject:imageView];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(enterButton:)]) {
        // 获取最后一张视图
        UIImageView *lastImageView = _imageArray.lastObject;
        
        // 添加登录按钮
        UIButton *enterButton = [self.delegate enterButton:self];
        [enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
        [lastImageView addSubview:enterButton];
    }
    
    // 配置动画
    NSString *ClassName;
    switch (animateType) {
        case JXViewPagerAnimateDefault:
            ClassName = nil;
            break;
            
        case JXViewPagerAnimateZoom:
            ClassName = @"JXZoomAnimate";
            break;
            
        default:
            ClassName = nil;
            break;
    }
    
    _launchAnimate = nil;
    
    if (ClassName) {
        Class animatedClass = NSClassFromString(ClassName);
        
        if (animatedClass)
            _launchAnimate = [[animatedClass alloc] init];
    }
}

/**
 *  登录
 */
- (void)enter:(id)sender
{
    // 首次登录记录
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:JX_FIRST_LOGIN_KEY];
    [[NSUserDefaults standardUserDefaults ] synchronize];

    // 渐变动画
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollView.userInteractionEnabled = NO;
        _scrollView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_launchWindow resignKeyWindow];
        
    }];
    
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewPagerDidEnter)]) {
        [self.delegate viewPagerDidEnter];
    }
}

/**
 *  删除缓存标记
 */
+ (void)removeCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JX_FIRST_LOGIN_KEY];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_launchAnimate) {
        [_launchAnimate animateWithImageViews:_imageArray
                      scrollViewContentOffset:scrollView.contentOffset.x];
    }
}

@end
