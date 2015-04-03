//
// FilterDetailViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/3/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "FilterDetailViewController.h"

@import GLKit;

@interface FilterDetailViewController ()

@property (weak, nonatomic) GLKView *glView;
@property (assign, nonatomic) CGRect sourceRect;
@property (assign, nonatomic) CGRect targetRect;

@end

@implementation FilterDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.glView.context = self.eaglContext;

    self.sourceRect = CGRectZero;
    self.targetRect = CGRectZero;

    self.navigationItem.title = self.filter.attributes[kCIAttributeFilterDisplayName];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.targetRect = self.view.bounds;
    self.sourceRect = self.targetRect;
}

- (void)renderImage
{
    [self.ciContext drawImage:self.filter.outputImage inRect:self.targetRect fromRect:self.sourceRect];
    [self.glView display];
}

@end
