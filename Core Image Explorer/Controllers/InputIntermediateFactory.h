//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractInputIntermediate;
@protocol FilterControlsDelegate;


@interface InputIntermediateFactory : NSObject

+ (AbstractInputIntermediate *)createIntermediateForInput:(NSString *)inputName
                                                forFilter:(CIFilter *)filter;

@end