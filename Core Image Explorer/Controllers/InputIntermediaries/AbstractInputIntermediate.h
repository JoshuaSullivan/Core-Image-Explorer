//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;

#import "InputIntermediateDelegate.h"

@interface AbstractInputIntermediate : NSObject

@property (weak, nonatomic) id <InputIntermediateDelegate> delegate;

@property (readonly, nonatomic) NSString *inputName;
@property (readonly, nonatomic) NSDictionary *inputAttributes;
@property (readonly, nonatomic) id inputStartingValue;
@property (readonly, nonatomic) UIViewController *inputViewController;

- (instancetype)initWithInput:(NSString *)inputName forFilter:(CIFilter *)filter;

@end