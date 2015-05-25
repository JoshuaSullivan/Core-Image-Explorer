//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "AbstractInputIntermediate.h"
#import "InputIntermediateDelegate.h"
#import "FilterControlsViewController.h"

@interface AbstractInputIntermediate ()

@end

@implementation AbstractInputIntermediate

- (instancetype)initWithInput:(NSString *)inputName forFilter:(CIFilter *)filter
{
    self = [super init];
    if (!self) {
        NSLog(@"ERROR: Unable to instantiate AbstractInputIntermediate");
    }
    _inputName = inputName;
    _inputAttributes = filter.attributes[inputName];
    _inputStartingValue = [filter valueForKey:inputName];

    return self;
}

- (UIViewController *)inputViewController
{
    NSAssert(NO, @"Child classes must implement inputViewController and not invoke the base implementation.");
    return nil;
}


@end