//
// MinimalistInputDescriptor.h
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/1/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import <Foundation/Foundation.h>


@interface MinimalistInputDescriptor : NSObject

@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) CGFloat minValue;
@property (readonly, nonatomic) CGFloat maxValue;
@property (readonly, nonatomic) CGFloat startingValue;

+ (MinimalistInputDescriptor *)inputDescriptorWithTitle:(NSString *)title minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue startingValue:(CGFloat)startingValue;

- (instancetype)initWithTitle:(NSString *)title minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue startingValue:(CGFloat)startingValue;

@end
