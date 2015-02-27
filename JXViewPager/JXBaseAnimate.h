//
//  JXBaseAnimate.h
//  demo
//
//  Created by andy on 2/27/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXBaseAnimate : NSObject

/**
 *  滚动动画
 *
 *  @param imageViews    图片
 *  @param contentOffset 滚动偏移量
 */
- (void)animateWithImageViews:(NSArray *)imageViews
      scrollViewContentOffset:(CGFloat)contentOffsetX;

@end
