//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "ScalarInputViewController.h"
@import CoreImage;

@interface ScalarInputViewController ()

@end

@implementation ScalarInputViewController

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSString *inputType = inputDictionary[kCIAttributeClass];
    if (![inputType isEqualToString:NSStringFromClass([NSNumber class])]) {
        return NO;
    }
    return YES;
}

@end
