//
// SlideFromRightAnimationController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "SlideFromRightAnimationController.h"

@implementation SlideFromRightAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        [self presentWithContext:transitionContext];
    } else {
        [self dismissWithContext:transitionContext];
    }
}

- (void)presentWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect toBounds = toView.bounds;
    CGSize containerSize = transitionContext.containerView.bounds.size;
    CGRect endFrame = CGRectMake(containerSize.width - toBounds.size.width, 0.0f, toBounds.size.width, toBounds.size.height);
    CGRect startFrame = CGRectOffset(endFrame, toBounds.size.width, 0.0f);
    toView.frame = startFrame;
    [transitionContext.containerView addSubview:toView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.frame = endFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect startFrame = toView.frame;
    CGRect endFrame = CGRectOffset(startFrame, startFrame.size.width, 0.0f);
    toView.frame = startFrame;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.frame = endFrame;
    } completion:^(BOOL finished) {
        [toView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
