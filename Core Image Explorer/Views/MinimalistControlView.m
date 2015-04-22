//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistControlView.h"

@interface MinimalistControlView ()

@property (assign, nonatomic, getter=isHorizontal) BOOL horizontal;
@property (strong, nonatomic) UIView *indicator;
@property (strong, nonatomic)

@end

@implementation MinimalistControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _horizontal = frame.size.width > frame.size.height;
    _indicator = [[UIView alloc] initWithFrame:CGRectZero];
    if (_horizontal) {
        _indicator.frame = CGRectMake(0.0f, 0.0f, 1.0f, frame.size.height);
        _indicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HairlinePatternVertical"]];
    } else {
        _indicator.frame = CGRectMake(0.0f, 0.0f, frame.size.width, 1.0f);
        _indicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HairlinePatternHorizontal"]];
    }
    [self addSubview:_indicator];
    return self;
}

#pragma mark - Getters & Setters

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.value = fmaxf(minValue, self.value);
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    self.value = fminf(maxValue, self.value);
}

- (void)setValue:(CGFloat)value
{
    _value = value;

}

@end