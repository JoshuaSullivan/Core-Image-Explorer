//
//  MinimalistInputViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MinimalistControlDelegate;

@interface MinimalistInputViewController : UIViewController

@property (weak, nonatomic) id <MinimalistControlDelegate> delegate;

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSUInteger)inputCount valueRanges:(NSArray *)ranges;

/**
* Creates and returns an initialized instance of MinimalistInputViewController.
*
* @param inputCount The number of discrete inputs to create.
* @param ranges For one input, an array of 2-3 NSNumber objects [min, max, (optional)value]. For more than 1 input, an array of NSArrays, each containing 2-3 NSNumbers. If the 3rd number is omitted from any of the range arrays, the value will be set to the minimum.
*/
- (instancetype)initWithInputCount:(NSUInteger)inputCount valueRanges:(NSArray *)ranges;

- (void)setMinimumValue:(CGFloat)minVal maximumValue:(CGFloat)maxVal forInputIndex:(NSUInteger)index;

- (CGFloat)valueForInputIndex:(NSUInteger)index;

@end

@protocol MinimalistControlDelegate <NSObject>

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index;

@end
