//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;

static const CGFloat kDefaultControlInsetsDistance = 20.0f;

@interface MinimalistControlView : UIView

@property (strong, nonatomic) NSString *valueName;
@property (assign, nonatomic) CGFloat minValue;
@property (assign, nonatomic) CGFloat maxValue;
@property (readonly, nonatomic) CGFloat value;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (instancetype)initWithMinimumValue:(CGFloat)minValue maximumValue:(CGFloat)maxValue currentValue:(CGFloat)value;

- (void)setValue:(CGFloat)value animated:(BOOL)animated;

@end