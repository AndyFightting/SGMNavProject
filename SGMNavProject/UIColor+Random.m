//
//  SGMNavigationController.h
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)
+ (UIColor *)randomColor {
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end
