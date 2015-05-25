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
#import "FilterControlsPresentationController.h"

@interface FilterDetailViewController () <FilterControlsDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) CIFilter *filter;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) CGRect sourceRect;
@property (assign, nonatomic) CGRect targetRect;
@property (strong, nonatomic) CIContext *ciContext;
@property (assign, atomic) BOOL isRendering;

@property (strong, nonatomic) FilterControlsViewController *filterControls;
@property (strong, nonatomic) FilterControlsPresentationController *filterPresentationController;

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

    self.navigationItem.title = self.filterDescriptor[kCIAttributeFilterDisplayName];
    self.view.tintColor = [UIColor blackColor];

    self.filter = [CIFilter filterWithName:self.filterDescriptor[kCIAttributeFilterName]];
    self.filterControls = [[FilterControlsViewController alloc] initWithFilter:self.filter];
    self.filterControls.filterControlsDelegate = self;
    self.filterControls.modalPresentationStyle = UIModalPresentationCustom;
    self.filterControls.transitioningDelegate = self;

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
    [coordinator animateAlongsideTransition:nil completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        [self renderImage];
    }];
}

- (void)renderImage
{
    if (self.isRendering) {
        // Only start a render while one is not in progress.
        return;
    }
    self.isRendering = YES;
    // Since the filter is mutable and could be modified by another class while rendering is in progress, we'll duplicate it.
    CIFilter *workingFilter = [self.filter copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *inputImage = workingFilter.outputImage;
        CGImageRef renderImage = [self.ciContext createCGImage:inputImage fromRect:self.sourceRect];
        UIImage *finalImage = [UIImage imageWithCGImage:renderImage];
        CGImageRelease(renderImage);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = finalImage;
            self.isRendering = NO;
        });
    });

//    [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample2 completion:^(UIImage *image) {
//        self.imageView.image = image;
//    }];
}

#pragma mark - Filter Controls

- (void)filterControlsViewController:(FilterControlsViewController *)filterControlsViewController
        didChangeFilterConfiguration:(CIFilter *)filter
{
    [self renderImage];
}

- (void)filterControlsViewController:(FilterControlsViewController *)filterControlsViewController didRequestFullScreen:(BOOL)fullScreen
{
    self.fullScreen = fullScreen;
}


#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self setFullScreen:!self.isFullScreen];
}

- (IBAction)configTapped:(id)sender
{
    [self presentViewController:self.filterControls animated:YES completion:nil];
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

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    if (presented == self.filterControls) {
        return [[FilterControlsPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    }
    return nil;
}


@end
