//
// SlideFromRightAnimationController.h
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import <Foundation/Foundation.h>


@interface SlideFromRightAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic, getter=isPresenting) BOOL presenting;

@end
