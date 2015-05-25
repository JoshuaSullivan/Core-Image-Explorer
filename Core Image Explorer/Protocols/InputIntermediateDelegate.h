//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InputIntermediateDelegate <NSObject>

- (void)inputIntermediate:(id)inputIntermediate didSetValue:(id)value forInput:(NSString *)inputName;
- (void)inputIntermedateDidComplete:(id)inputIntermediate;

@end