//
// FilterDetailViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/3/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "FilterDetailViewController.h"

@import GLKit;

@interface FilterDetailViewController ()

@property (weak, nonatomic) IBOutlet GLKView *glView;
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

//    UIImage *image = [UIImage imageNamed:@"Sample1"];
//    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
//    [self.filter setValue:ciImage forKey:kCIInputImageKey];
//    CGRect extent = [ciImage extent];

    self.navigationItem.title = self.filter.attributes[kCIAttributeFilterDisplayName];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.targetRect = self.glView.bounds;
    self.sourceRect = self.targetRect;
    
    [self renderImage];
}

- (void)renderImage
{
    CIImage *renderImage = self.filter.outputImage;
    [self.ciContext drawImage:renderImage inRect:self.targetRect fromRect:self.sourceRect];
    [self.glView display];
}

@end
