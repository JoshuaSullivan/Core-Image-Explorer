//
// FilterControlsPresentationController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 5/4/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "FilterControlsPresentationController.h"
#import "FilterControlsViewController.h"

@interface FilterControlsPresentationController ()

@property (strong, nonatomic) UIView *tapView;

@end

@implementation FilterControlsPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (!self) {
        NSAssert(NO, @"ERROR: Unable to instantiate FilterControlsPresentationController.");
        return nil;
    }

    _tapView = [[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_tapView addGestureRecognizer:tapGestureRecognizer];
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentationTransitionWillBegin
{
    [super presentationTransitionWillBegin];

    self.tapView.frame = self.containerView.bounds;
    [self.containerView insertSubview:self.tapView atIndex:0];
}

- (void)dismissalTransitionWillBegin
{
    [super dismissalTransitionWillBegin];

    [self.tapView removeFromSuperview];
}

- (CGSize)sizeForChildContentContainer:(id <UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (parentSize.width > parentSize.height) {
        return CGSizeMake(280.0f, parentSize.height);
    } else {
        FilterControlsViewController *filterControlsVC = (FilterControlsViewController *)container;
        CGFloat halfHeight = roundf(parentSize.height / 2.0f);
        CGFloat contentHeight = [filterControlsVC contentHeight];
        return CGSizeMake(parentSize.width, fminf(halfHeight, contentHeight));
    }
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerBounds = self.containerView.bounds;
    CGSize modalSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerBounds.size];
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    if (containerBounds.size.width > containerBounds.size.height) {
        x = containerBounds.size.width - modalSize.width;
    } else {
        y = containerBounds.size.height - modalSize.height;
    }
    return CGRectMake(x, y, modalSize.width, modalSize.height);
}


@end
