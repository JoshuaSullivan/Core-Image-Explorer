//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistControlView.h"
#import "VanishingValueLabel.h"

@interface MinimalistControlView ()

@property (assign, nonatomic, getter=isHorizontal) BOOL horizontal;
@property (strong, nonatomic) UIView *indicator;
@property (strong, nonatomic) VanishingValueLabel *valueLabel;
@property (assign, nonatomic, getter=isTracking) BOOL tracking;

@end

@implementation MinimalistControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _edgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    _horizontal = frame.size.width > frame.size.height;
    _indicator = [[UIView alloc] initWithFrame:CGRectZero];
    if (_horizontal) {
        _indicator.frame = CGRectMake(0.0f, 0.0f, 1.0f, frame.size.height);
//        _indicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HairlinePatternVertical"]];
        _indicator.backgroundColor = [UIColor blackColor];
    } else {
        _indicator.frame = CGRectMake(0.0f, 0.0f, frame.size.width, 1.0f);
//        _indicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HairlinePatternHorizontal"]];
        _indicator.backgroundColor = [UIColor blackColor];
    }
    [self addSubview:_indicator];
    return self;
}

- (void)setValueForPoint:(CGPoint)location
{
    CGFloat ratio = 0.0f;
    if (self.isHorizontal) {
        if (self.bounds.size.width != 0.0f) {
            ratio = (location.x - self.edgeInsets.left) / (self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right);
        }
    } else {
        if (self.bounds.size.height != 0.0f) {
            CGFloat topFactor = location.y - self.edgeInsets.top;
            CGFloat bottomFactor = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
            ratio = topFactor / bottomFactor;
        }
    }
    ratio = fmaxf(0.0f, fminf(ratio, 1.0f));
    DLog(@"ratio: %f", ratio);
    self.value = ratio * (self.maxValue - self.minValue) + self.minValue;
}

- (void)updateIndicator
{
    CGFloat ratio = 0.0f;
    if (self.minValue != self.maxValue) {
        ratio = (self.value - self.minValue) / (self.maxValue - self.minValue);
    }
    CGRect indicatorFrame = self.indicator.frame;
    if (self.isHorizontal) {
        CGFloat w = self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right;
        indicatorFrame.origin.x = w * ratio + self.edgeInsets.left;
    } else {
        CGFloat h = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
        indicatorFrame.origin.y = h * ratio + self.edgeInsets.top;
    }
    self.indicator.frame = indicatorFrame;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setValueForPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setValueForPoint:[touch locationInView:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setValueForPoint:[touch locationInView:self]];
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
    _value = fmaxf(self.minValue, fminf(value, self.maxValue));
    DLog(@"value: %@", @(_value));
    self.valueLabel.value = [NSString stringWithFormat:@"%0.2f", _value];
    [self updateIndicator];
}

@end