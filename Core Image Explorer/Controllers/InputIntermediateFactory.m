//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "InputIntermediateFactory.h"
#import "AbstractInputIntermediate.h"
#import "FilterControlsViewController.h"
#import "ColorInputIntermediate.h"

@implementation InputIntermediateFactory

+ (AbstractInputIntermediate *)createIntermediateForInput:(NSString *)inputName
                                                forFilter:(CIFilter *)filter
{
    NSDictionary *inputAttributes = filter.attributes[inputName];
    NSString *inputClass = inputAttributes[kCIAttributeClass];
    
    if ([inputClass isEqualToString:@"NSNumber"]) {
        //TODO: Create a scalar intermediate
    } else if ([inputClass isEqualToString:@"CIColor"]) {
        ColorInputIntermediate *colorInt = [[ColorInputIntermediate alloc] initWithInput:inputName forFilter:filter];
        //TODO: Determine if we ever need to disable the alpha channel.
        return colorInt;
    }
    
    return nil;
}


@end