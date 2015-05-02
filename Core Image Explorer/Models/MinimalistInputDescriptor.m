//
// MinimalistInputDescriptor.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/1/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "MinimalistInputDescriptor.h"

@implementation MinimalistInputDescriptor

+ (MinimalistInputDescriptor *)inputDescriptorWithTitle:(NSString *)title
                                               minValue:(CGFloat)minValue
                                               maxValue:(CGFloat)maxValue
                                          startingValue:(CGFloat)startingValue
{
    return [[self alloc] initWithTitle:title minValue:minValue maxValue:maxValue startingValue:startingValue];
}

- (instancetype)initWithTitle:(NSString *)title
                     minValue:(CGFloat)minValue
                     maxValue:(CGFloat)maxValue
                startingValue:(CGFloat)startingValue
{
    self = [super init];
    if (!self) {
        NSAssert(NO, @"ERROR: Unable to instantiate MinimalistInputDescriptor.");
        return nil;
    }
    _title = title;
    _minValue = minValue;
    _maxValue = maxValue;
    _startingValue = fmaxf(minValue, fminf(startingValue, maxValue));
    return self;
}

@end
