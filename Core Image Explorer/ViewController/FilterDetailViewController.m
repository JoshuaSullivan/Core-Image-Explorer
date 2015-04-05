//
// FilterDetailViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/3/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "FilterDetailViewController.h"

@interface FilterDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) CGRect sourceRect;
@property (assign, nonatomic) CGRect targetRect;
@property (strong, nonatomic) CIContext *ciContext;

@end

@implementation FilterDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.ciContext = [CIContext contextWithEAGLContext:eaglContext];

    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGRect screenSize = [UIScreen mainScreen].bounds;
    self.sourceRect = screenSize;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(screenScale, screenScale);
    self.targetRect = CGRectApplyAffineTransform(screenSize, scaleTransform);

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];

    self.navigationItem.title = self.filter.attributes[kCIAttributeFilterDisplayName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self renderImage];
}

- (void)renderImage
{
    CIImage *inputImage = self.filter.outputImage;
    CGImageRef renderImage = [self.ciContext createCGImage:inputImage fromRect:self.sourceRect];
    UIImage *finalImage = [UIImage imageWithCGImage:renderImage];
    self.imageView.image = finalImage;
    CGImageRelease(renderImage);
}

#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self renderImage];
}

@end
