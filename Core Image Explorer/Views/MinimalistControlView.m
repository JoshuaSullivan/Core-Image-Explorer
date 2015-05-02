//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistControlView.h"
#import "VanishingValueLabel.h"
#import "JTSTweener.h"
#import "JTSEaseQuadratic.h"
#import "MinimalistInputDescriptor.h"

@interface MinimalistControlView ()

@property (assign, nonatomic) CGFloat minValue;
@property (assign, nonatomic) CGFloat maxValue;
@property (assign, nonatomic) CGFloat value;
@property (assign, nonatomic, getter=isHorizontal) BOOL horizontal;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) VanishingValueLabel *valueLabel;
@property (assign, nonatomic, getter=isTracking) BOOL tracking;
@property (assign, nonatomic) BOOL userChangedValue;
@property (assign, nonatomic) CGPoint lastTouch;
@property (strong, nonatomic) JTSTweener *valueTweener;

@end

@implementation MinimalistControlView

- (instancetype)initWithDescriptor:(MinimalistInputDescriptor *)descriptor
{
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        NSAssert(NO, @"ERROR: Unable to instantiate MinimalistControlView.");
        return nil;
    }
    _descriptor = descriptor;
    _minValue = descriptor.minValue;
    _maxValue = descriptor.maxValue;
    _value = descriptor.startingValue;

    [self commonInit];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
    self.horizontal = self.bounds.size.width > self.bounds.size.height;
    [self updateIndicatorAnimated:NO];
}

- (void)commonInit
{
    CGFloat d = kDefaultControlInsetsDistance;
    self.edgeInsets = UIEdgeInsetsMake(d, d, d, d);
    self.lastTouch = CGPointZero;
    self.indicator = [[UIImageView alloc] initWithImage:nil];
    self.indicator.contentMode = UIViewContentModeTopLeft;
    self.indicator.clipsToBounds = YES;
    [self addSubview:self.indicator];

    if (!self.valueLabel) {
        self.valueLabel = [[VanishingValueLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 80.0f)];
        [self addSubview:self.valueLabel];
    }

    if (self.descriptor) {
        self.valueLabel.title = self.descriptor.title;
        self.valueLabel.value = [NSString stringWithFormat:@"%0.2f", self.descriptor.startingValue];
    }
}

- (void)setValueForPoint:(CGPoint)location
{
    self.userChangedValue = YES;
    self.lastTouch = location;
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
    self.value = ratio * (self.maxValue - self.minValue) + self.minValue;
    CGRect indicatorFrame = self.indicator.frame;
    if (self.isHorizontal) {
        CGFloat x = roundf(location.x);
        indicatorFrame.origin.x = x;
    } else {
        CGFloat y = roundf(location.y);
        indicatorFrame.origin.y = y;
    }
    self.indicator.frame = indicatorFrame;
}

- (void)updateIndicatorAnimated:(BOOL)animated
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
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.indicator.frame = indicatorFrame;
        }];
    } else {
        self.indicator.frame = indicatorFrame;
    }
}

- (void)updateLabelPosition
{
    CGFloat w = self.valueLabel.bounds.size.width;
    CGFloat h = self.valueLabel.bounds.size.height;
    CGFloat y =  roundf((self.bounds.size.height - h) / 2.0f);
    CGFloat x = roundf((self.bounds.size.width - w) / 2.0f);
    self.valueLabel.frame = CGRectMake(x, y, w, h);
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

#pragma mark - Getters & Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.horizontal = frame.size.width > frame.size.height;
    [self updateIndicatorAnimated:NO];
    [self updateLabelPosition];
}

- (void)setDescriptor:(MinimalistInputDescriptor *)descriptor
{
    _descriptor = descriptor;
    self.valueLabel.title = descriptor.title;
    self.minValue = descriptor.minValue;
    self.maxValue = descriptor.maxValue;
    if (!self.userChangedValue) {
        self.value = descriptor.startingValue;
    }
}

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

- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    if (self.value == value) {
        return;
    }
    if (self.valueTweener) {
        [self.valueTweener cancel];
        self.valueTweener = nil;
    }
    if (animated) {
        self.valueTweener = [JTSTweener tweenerWithDuration:0.2
                                              startingValue:self.value
                                                endingValue:value
                                                easingCurve:[JTSEaseQuadratic easeInOut]
                                                    options:nil
                                              progressBlock:^(JTSTweener *tween, CGFloat value, NSTimeInterval elapsedTime) {
                                                  self.value = value;
                                              }
                                            completionBlock:^(JTSTweener *tween, BOOL completedSuccessfully) {
                                                self.valueTweener = nil;
                                            }];
    } else {
        self.value = value;
    }
    [self updateIndicatorAnimated:animated];
}

- (void)setValue:(CGFloat)value
{
    _value = fmaxf(self.minValue, fminf(value, self.maxValue));
    self.valueLabel.value = [NSString stringWithFormat:@"%0.2f", _value];
}

- (void)setHorizontal:(BOOL)horizontal
{
    _horizontal = horizontal;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    if (horizontal) {
        self.indicator.frame = CGRectMake(0.0f, 0.0f, 1.0f, h);
        self.indicator.image = [UIImage imageNamed:@"HairlineVertical"];
    } else {
        self.indicator.frame = CGRectMake(0.0f, 0.0f, w, 1.0f);
        self.indicator.image = [UIImage imageNamed:@"HairlineHorizontal"];
    }
    [self updateLabelPosition];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self updateLabelPosition];
}

- (void)setIndicatorHidden:(BOOL)indicatorHidden
{
    _indicatorHidden = indicatorHidden;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.alpha = indicatorHidden ? 0.0f : 1.0f;
    }];
}

@end