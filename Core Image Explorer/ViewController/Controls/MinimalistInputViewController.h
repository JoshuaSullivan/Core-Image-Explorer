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

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSInteger)inputCount valueRanges:(NSArray *)ranges;

- (instancetype)initWithInputCount:(NSInteger)inputCount valueRanges:(NSArray *)ranges;

- (void)setMinimumValue:(CGFloat)minVal maximumValue:(CGFloat)maxVal forInputIndex:(NSInteger)index;

- (CGFloat)valueForInputIndex:(NSInteger)index;

@end

@protocol MinimalistControlDelegate <NSObject>

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index;

@end
