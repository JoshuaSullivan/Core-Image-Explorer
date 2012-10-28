//
//  UIImage+Transform.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/27/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Transform)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end
