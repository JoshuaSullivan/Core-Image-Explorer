//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "InputIntermediateFactory.h"
#import "AbstractInputIntermediate.h"
#import "FilterControlsViewController.h"
#import "ColorInputIntermediate.h"
#import "ScalarInputIntermediate.h"

static NSString *kCIInputMessage = @"inputMessage";
static NSString *kCIInputCubeData = @"inputCubeData";

@implementation InputIntermediateFactory

// Input Classes: CIImage, NSNumber, NSValue, CIVector, NSData, CIColor, NSObject, NSString

+ (AbstractInputIntermediate *)createIntermediateForInput:(NSString *)inputName
                                                forFilter:(CIFilter *)filter
{
    NSDictionary *inputAttributes = filter.attributes[inputName];
    NSString *inputClass = inputAttributes[kCIAttributeClass];
    NSString *filterName = filter.attributes[kCIAttributeFilterName];
    
    if ([inputClass isEqualToString:@"NSNumber"]) {
        ScalarInputIntermediate *scalarInt = [[ScalarInputIntermediate alloc] initWithInput:inputName forFilter:filter];
        return scalarInt;
    } else if ([inputClass isEqualToString:@"CIVector"]) {
        return [self createIntermediateForVectorInput:inputName withAttributes:inputAttributes];
    } else if ([inputClass isEqualToString:@"CIColor"]) {
        ColorInputIntermediate *colorInt = [[ColorInputIntermediate alloc] initWithInput:inputName forFilter:filter];
        //TODO: Determine if we ever need to disable the alpha channel.
        return colorInt;
    } else if ([inputClass isEqualToString:@"NSValue"]) {
        if ([inputName isEqualToString:kCIInputTransformKey]) {
            //TODO: This is a CGAffineTransform input.
        } else {
            NSAssert(@"ERROR: Unhandled NSValue input '%@' on filter %@", inputName, filterName);
        }
    } else if ([inputClass isEqualToString:@"CIImage"]) {
        //TODO: This is an image input.
    } else if ([inputClass isEqualToString:@"NSData"]) {
        if ([inputName isEqualToString:kCIInputMessage]) {
            //TODO: Input for a Code Generator (QR, Bar, Aztec, etc.)
        } else if ([inputName isEqualToString:kCIInputCubeData]) {
            //TODO: Input data for a color cube.
        } else {
            NSAssert(@"ERROR: Unhandled NSData input '%@' on filter %@", inputName, filterName);
        }
    } else if ([inputClass isEqualToString:@"NSString"]) {
        //TODO: This is only used by the QR Code Generator.
    } else if ([inputClass isEqualToString:@"NSObject"]) {
        //TODO: This is only used by CIColorCubeWithColorSpace. Type is CGColorSpaceRef.
    } else {
        NSAssert(NO, @"ERROR: Unhandled input class '%@", inputClass);
    }
    
    return nil;
}

/** Breaking this off into its own method because there are a lot of different data types encoded by CIVector. */
+ (AbstractInputIntermediate *)createIntermediateForVectorInput:(NSString *)inputName withAttributes:(NSDictionary *)inputAttributes
{
    NSString *inputType = inputAttributes[kCIAttributeType];
    if (!inputType) {
        // CIVector inputs with no type. Infer from name instead.
    } else if ([inputType isEqualToString:kCIAttributeTypeOffset]) {
        // Offset types
    } else if ([inputType isEqualToString:kCIAttributeTypePosition]) {
        // Position types
    } else if ([inputType isEqualToString:kCIAttributeTypeRectangle]) {
        // Rectangle types
    } else {
        NSAssert(NO, @"ERROR: Unhandled CIVector input type: %@", inputType);
    }
    return nil;
}

@end