//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;@class MinimalistInputDescriptor;

static const CGFloat kDefaultControlInsetsDistance = 20.0f;

@interface MinimalistControlView : UIView

@property (readonly, nonatomic) CGFloat value;
@property (strong, nonatomic) MinimalistInputDescriptor *descriptor;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (instancetype)initWithDescriptor:(MinimalistInputDescriptor *)descriptor;

- (void)setValue:(CGFloat)value animated:(BOOL)animated;

@end