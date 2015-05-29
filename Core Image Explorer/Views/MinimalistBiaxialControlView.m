//
// MinimalistBiaxialControlView.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/29/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import <JTSTweener/JTSTweener.h>
#import <JTSTweener/JTSEaseQuadratic.h>
#import "MinimalistBiaxialControlView.h"
#import "VanishingValueLabel.h"

@interface MinimalistBiaxialControlView ()

@property (assign, nonatomic) CGPoint value;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) FloatRange xRange;
@property (assign, nonatomic) FloatRange yRange;
@property (strong, nonatomic) VanishingValueLabel *valueLabel;

@end

@implementation MinimalistBiaxialControlView

- (instancetype)initWithTitle:(NSString *)title xRange:(FloatRange)xRange yRange:(FloatRange)yRange
{
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        NSLog(@"ERROR: Unable to instantiate MinimalistBiaxialControlView");
        return nil;
    }
    _xRange = xRange;
    _yRange = yRange;
    _title = title;
    [self commonInit];
    return self;
}

- (void)commonInit
{
    _edgeInsets = UIEdgeInsetsMake(kDefaultControlInsetsDistance, kDefaultControlInsetsDistance, kDefaultControlInsetsDistance, kDefaultControlInsetsDistance);
}

- (void)updateLayoutWithPoint:(CGPoint)point
{

}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setValueForPoint:[touch locationInView:self]];
    [self.valueLabel appear];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setValueForPoint:[touch locationInView:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.valueLabel vanish];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.valueLabel vanish];
}

#pragma mark - Getters & Setters

- (void)setValue:(CGPoint)value
{
    _value = value;

}

- (void)setValue:(CGPoint)value animated:(BOOL)animated
{
    value.x = fmaxf(self.xRange.min, fminf(value.x, self.xRange.max));
    value.y = fmaxf(self.yRange.min, fminf(value.y, self.yRange.max));
    if (!animated) {
        self.value = value;
        [self updateLayoutWithPoint:[self derivePointFromCurrentValue]];
        return;
    }
    CGFloat startX = self.value.x;
    CGFloat startY = self.value.y;
    CGFloat dx = value.x - startX;
    CGFloat dy = value.y - startY;
    [JTSTweener tweenerWithDuration:0.4 startingValue:0.0f endingValue:1.0f easingCurve:[JTSEaseQuadratic easeInOut] options:nil progressBlock:^(JTSTweener *tween, CGFloat tweenValue, NSTimeInterval elapsedTime) {
        CGFloat x = startX + dx * tweenValue;
        CGFloat y = startY + dy * tweenValue;
        self.value = CGPointMake(x, y);
        [self updateLayoutWithPoint:[self derivePointFromCurrentValue]];
    } completionBlock:^(JTSTweener *tween, BOOL completedSuccessfully) {
        self.value = value;
    }];
}

- (void)setValueForPoint:(CGPoint)point
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat xRatio = (point.x - self.edgeInsets.left) / (w - self.edgeInsets.left - self.edgeInsets.right);
    CGFloat yRatio = (point.y - self.edgeInsets.top) / (h - self.edgeInsets.top - self.edgeInsets.bottom);
    xRatio = fmaxf(0.0f, fminf(xRatio, 1.0f));
    yRatio = fmaxf(0.0f, fminf(yRatio, 1.0f));
    CGFloat x = xRatio * (self.xRange.max - self.xRange.min) + self.xRange.min;
    CGFloat y = yRatio * (self.yRange.max - self.yRange.min) + self.yRange.min;
    self.value = CGPointMake(x, y);
    [self updateLayoutWithPoint:point];
}

#pragma mark - Helpers

- (CGPoint)derivePointFromCurrentValue
{
    CGFloat xRatio = (self.value.x - self.xRange.min) / (self.xRange.max - self.xRange.min);
    CGFloat yRatio = (self.value.y - self.yRange.min) / (self.yRange.max - self.yRange.min);
    CGFloat x = (self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right) * xRatio + self.edgeInsets.left;
    CGFloat y = (self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom) * yRatio + self.edgeInsets.top;
    return CGPointMake(x, y);
}

@end
