//
// FilterDetailViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/3/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "FilterDetailViewController.h"
#import "FilterControlsViewController.h"
#import "MinimalistControlView.h"
#import "SampleImageManager.h"
#import "MinimalistInputViewController.h"
#import "MinimalistInputDescriptor.h"

@interface FilterDetailViewController () <MinimalistControlDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) CGRect sourceRect;
@property (assign, nonatomic) CGRect targetRect;
@property (strong, nonatomic) CIContext *ciContext;

@property (assign, nonatomic, getter=isFullScreen) BOOL fullScreen;

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
    self.view.tintColor = [UIColor blackColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self renderImage];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
                                     [self renderImage];
                                 }];
}

- (void)renderImage
{
    CIImage *inputImage = self.filter.outputImage;
    CGImageRef renderImage = [self.ciContext createCGImage:inputImage fromRect:self.sourceRect];
    UIImage *finalImage = [UIImage imageWithCGImage:renderImage];
    self.imageView.image = finalImage;
    CGImageRelease(renderImage);
//    [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample2 completion:^(UIImage *image) {
//        self.imageView.image = image;
//    }];
}

#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self setFullScreen:!self.isFullScreen];
}

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index
{
    DLog(@"[%li] value: %0.2f", (long)index, value);
}

- (void)minimalistControlShouldClose:(MinimalistInputViewController *)minimalistController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setFullScreen:NO];
}

- (IBAction)configTapped:(id)sender
{
    DLog(@"Config!");
}

#pragma mark - Getters & Setters

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    [self.navigationController setNavigationBarHidden:fullScreen animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return self.fullScreen;
}


@end
