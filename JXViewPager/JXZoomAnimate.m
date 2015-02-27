//
//  JXZoomAnimate.m
//  demo
//
//  Created by andy on 2/27/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import "JXZoomAnimate.h"

@implementation JXZoomAnimate

- (void)animateWithImageViews:(NSArray *)imageViews scrollViewContentOffset:(CGFloat)contentOffsetX
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    int previousIndex = contentOffsetX/width;
    int nextIndex = contentOffsetX/width + 1;
    
    UIImageView *previousView = imageViews[previousIndex];
   
    UIImageView *nextView;
    if (nextIndex < imageViews.count)
        nextView = imageViews[nextIndex];
    
    // 相对偏移量
    CGFloat relativePercent = ((int)contentOffsetX % (int)width) / width;
    
    // 透明度变化
    CGFloat alpha = 0.5;
    previousView.alpha = 1.0 - alpha*relativePercent;
    nextView.alpha = (1.0-alpha) + alpha*relativePercent;

    // 大小变化
    CGFloat zoom = 0.2;
    previousView.transform = CGAffineTransformMakeScale(1 - zoom*relativePercent,
                                                        1 - zoom*relativePercent);
    nextView.transform = CGAffineTransformMakeScale((1-zoom) + zoom*relativePercent,
                                                    (1-zoom) + zoom*relativePercent);
}

@end
