//
// MinimalistInputDescriptor.h
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/1/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import <Foundation/Foundation.h>


@interface MinimalistInputDescriptor : NSObject

/** The title appearing in the value label box. */
@property (readonly, nonatomic) NSString *title;

/** The minimum value for the control. */
@property (readonly, nonatomic) CGFloat minValue;

/** The maximum value for the control. */
@property (readonly, nonatomic) CGFloat maxValue;

/** The starting value for the control. */
@property (readonly, nonatomic) CGFloat startingValue;

/** An optional tint color to use for the control. If left nil, the default (parent-specified) tint color is used. */
@property (strong, nonatomic) UIColor *tintColor;

/** Convenience factory method with the same arguments as the designated initializer. */
+ (MinimalistInputDescriptor *)inputDescriptorWithTitle:(NSString *)title minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue startingValue:(CGFloat)startingValue;

/**
 *  Creates an initialized MinimalistInputDescriptor.
 *
 *  @param title         The title to appear in the value box.
 *  @param minValue      The minimum value for the control.
 *  @param maxValue      The maximum value for the control.
 *  @param startingValue The starting value for the control. It will be normalized to the range [minValue, maxValue] inclusive.
 *
 *  @return Returns an initialized instance of the descriptor.
 */
- (instancetype)initWithTitle:(NSString *)title minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue startingValue:(CGFloat)startingValue;

@end
