//
// MinimalistBiaxialControlView.h
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/29/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.

@import UIKit;

#import "FloatRange.h"

static const CGFloat kDefaultControlInsetsDistance = 20.0f;

@protocol MinimalistBiaxialInputDelegate;

@interface MinimalistBiaxialControlView : UIView

@property (readonly, nonatomic) CGPoint value;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (assign, nonatomic) BOOL integralValues;

@property (weak, nonatomic) id <MinimalistBiaxialInputDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title xRange:(FloatRange)xRange yRange:(FloatRange)yRange;

- (void)setValue:(CGPoint)value animated:(BOOL)animated;

@end

@protocol MinimalistBiaxialInputDelegate <NSObject>

- (void)minimalistBiaxialInput:(MinimalistBiaxialControlView *)input didSetValue:(CGPoint)value;

@end
