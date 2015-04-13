//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "BaseConfigurationViewController.h"

@interface BaseConfigurationViewController ()

@property (strong, nonatomic) CIFilter *filter;

@end

@implementation BaseConfigurationViewController

- (void)configureInputKey:(NSString *)key forFilter:(CIFilter *)filter
{
    NSDictionary *configDict = filter.attributes[key];
    if (!configDict) {
        NSAssert(NO, @"ERROR: No input found for key '%@'.", key);
        return;
    }

    if (![self isControlSuitableForInput:configDict]) {
        NSAssert(NO, @"This this control is not appropriate for the input '%@'.", key);
        return;
    }

    self.filter = filter;
}

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSAssert(NO, @"ERROR: Child classes must override isControlSuitableForInput:");
    return NO;
}
@end