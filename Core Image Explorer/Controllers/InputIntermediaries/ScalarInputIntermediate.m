//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "ScalarInputIntermediate.h"
#import "MinimalistInputViewController.h"
#import "MinimalistInputDescriptor.h"

@interface ScalarInputIntermediate () <MinimalistControlDelegate>

@property (strong, nonatomic) MinimalistInputViewController *inputVC;

@end

@implementation ScalarInputIntermediate

- (UIViewController *)inputViewController
{
    if (!self.inputVC) {
        NSNumber *minValueNumber = self.inputAttributes[kCIAttributeSliderMin];
        NSNumber *maxValueNumber = self.inputAttributes[kCIAttributeSliderMax];
        NSNumber *currentValueNumber = self.inputAttributes[kCIAttributeDefault];
        CGFloat minValue = minValueNumber ? [minValueNumber floatValue] : 0.0f;
        CGFloat maxValue = maxValueNumber ? [maxValueNumber floatValue] : minValue + 1.0f;
        CGFloat currentValue = currentValueNumber ? [currentValueNumber floatValue] : minValue;
        MinimalistInputDescriptor *descriptor = [MinimalistInputDescriptor inputDescriptorWithTitle:self.inputName
                                                                                           minValue:minValue
                                                                                           maxValue:maxValue
                                                                                      startingValue:currentValue];
        self.inputVC = [[MinimalistInputViewController alloc] initWithInputDescriptors:@[descriptor]];
        self.inputVC.delegate = self;
    }
    return self.inputVC;
}

#pragma mark - MinimalistControlDelegate

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(inputIntermediate:didSetValue:forInput:)]) {
        [self.delegate inputIntermediate:self didSetValue:@(value) forInput:self.inputName];
    }
}

- (void)minimalistControlShouldClose:(MinimalistInputViewController *)minimalistController
{
    if ([self.delegate respondsToSelector:@selector(inputIntermedateDidComplete:)]) {
        [self.delegate inputIntermedateDidComplete:self];
    }
}


@end