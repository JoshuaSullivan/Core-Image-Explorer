//
//  MinimalistInputViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MinimalistControlDelegate;
@class MinimalistInputDescriptor;

@interface MinimalistInputViewController : UIViewController

@property (weak, nonatomic) id <MinimalistControlDelegate> delegate;

+ (MinimalistInputViewController *)minimalistControlForDescriptors:(NSArray *)descriptors;

/**
* Creates and returns an initialized instance of MinimalistInputViewController.
*
* @param inputCount The number of discrete inputs to create.
* @param descriptors An array of MinimalistInputDescriptor objects. This array must have inputCount or greater members.
*/
- (instancetype)initWithInputDescriptors:(NSArray *)descriptors;

- (void)setDescriptor:(MinimalistInputDescriptor *)descriptor forInputIndex:(NSUInteger)index;

- (CGFloat)valueForInputIndex:(NSUInteger)index;

@end

@protocol MinimalistControlDelegate <NSObject>

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index;
- (void)minimalistControlShouldClose:(MinimalistInputViewController *)minimalistController;

@end
