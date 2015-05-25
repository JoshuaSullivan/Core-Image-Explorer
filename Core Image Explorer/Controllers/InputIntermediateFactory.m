//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "InputIntermediateFactory.h"
#import "AbstractInputIntermediate.h"
#import "FilterControlsViewController.h"
#import "ColorInputIntermediate.h"
#import "ScalarInputIntermediate.h"

@implementation InputIntermediateFactory

// Input Classes: CIImage, NSNumber, NSValue, CIVector, NSData, CIColor, NSObject, NSString

+ (AbstractInputIntermediate *)createIntermediateForInput:(NSString *)inputName
                                                forFilter:(CIFilter *)filter
{
    NSDictionary *inputAttributes = filter.attributes[inputName];
    NSString *inputClass = inputAttributes[kCIAttributeClass];
    
    if ([inputClass isEqualToString:@"NSNumber"]) {
        ScalarInputIntermediate *scalarInt = [[ScalarInputIntermediate alloc] initWithInput:inputName forFilter:filter];
        return scalarInt;
    } else if ([inputClass isEqualToString:@"CIColor"]) {
        ColorInputIntermediate *colorInt = [[ColorInputIntermediate alloc] initWithInput:inputName forFilter:filter];
        //TODO: Determine if we ever need to disable the alpha channel.
        return colorInt;
    }
    
    return nil;
}


@end