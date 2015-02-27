//
//  JXViewPager.h
//  demo
//
//  Created by andy on 2/27/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JXViewPager;
@protocol JXViewPagerDelegate <NSObject>
/**
 *  登录按钮被点击
 */
- (void)viewPagerDidEnter;

/**
 *  设置登录按钮
 */
- (UIButton *)enterButton:(JXViewPager *)viewPager;

@end


/// 动画类型
typedef enum {
    JXViewPagerAnimateDefault,   // 默认动画
    JXViewPagerAnimateZoom       // 大小缩放
}JXViewPagerAnimateType;

/// 启动页
@interface JXViewPager : NSObject
{

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
               animateType:(JXViewPagerAnimateType)animateType;

/**
 *  删除缓存标记（用于测试）
 */
+ (void)removeCache;
@end
