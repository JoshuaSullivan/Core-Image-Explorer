//
// Created by Joshua Sullivan on 4/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterControlsViewController.h"
#import "FilterControlAttributesTableViewController.h"
#import "SampleImageManager.h"

static NSString * const kStoryboardIdentifier = @"FilterControls";
static NSString * const kEmbedNavControllerSegueIdentifier = @"kEmbedNavControllerSegueIdentifier";

static NSString * const kGradientImageKey = @"inputGradientImage";

@interface FilterControlsViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) CIFilter *filter;

@end

@implementation FilterControlsViewController

- (instancetype)initWithFilter:(CIFilter *)filter
{
    self = [[UIStoryboard storyboardWithName:kStoryboardIdentifier bundle:nil] instantiateInitialViewController];
    if (!self) {
        NSLog(@"ERROR: Cannot create FilterControlsViewController from storyboard.");
        return nil;
    }
    _filter = filter;
    [self setDefaultImagesOnFilter:_filter];
    self.delegate = self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    FilterControlAttributesTableViewController *attributesVC = self.viewControllers[0];
    attributesVC.filter = self.filter;
}

- (void)setDefaultImagesOnFilter:(CIFilter *)filter
{
    for (NSString *key in filter.inputKeys) {
        if ([key isEqualToString:kCIInputImageKey]) {
            UIImage *existingImage = [filter valueForKey:key];
            if (!existingImage) {
                [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample1 completion:^(UIImage *sampleImage) {
                    [filter setValue:[CIImage imageWithCGImage:sampleImage.CGImage] forKey:key];
                    [self notifyDelegateOfFilterChange];
                }];
            }
        } else if ([key isEqualToString:kCIInputTargetImageKey] || [key isEqualToString:kCIInputBackgroundImageKey]) {
            UIImage *existingImage = [filter valueForKey:key];
            if (!existingImage) {
                [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample2 completion:^(UIImage *sampleImage) {
                    [filter setValue:[CIImage imageWithCGImage:sampleImage.CGImage] forKey:key];
                    [self notifyDelegateOfFilterChange];
                }];
            }
        } else if ([key isEqualToString:kCIInputMaskImageKey]) {
            NSString *filterName = filter.name;
            if ([filterName isEqualToString:@"CIBlendWithAlphaMask"]) {
                UIImage *existingImage = [filter valueForKey:key];
                if (!existingImage) {
                    [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample4 completion:^(UIImage *sampleImage) {
                        [filter setValue:[CIImage imageWithCGImage:sampleImage.CGImage] forKey:key];
                        [self notifyDelegateOfFilterChange];
                    }];
                }
            } else {
                UIImage *existingImage = [filter valueForKey:key];
                if (!existingImage) {
                    [[SampleImageManager sharedManager] getCompositionImageForSourceInCurrentOrientation:ImageSourceSample3 completion:^(UIImage *sampleImage) {
                        [filter setValue:[CIImage imageWithCGImage:sampleImage.CGImage] forKey:key];
                        [self notifyDelegateOfFilterChange];
                    }];
                }
            }
        } else if ([key isEqualToString:kGradientImageKey]) {
            //TODO: Figure out what the proper form of this input is.
            NSLog(@"Curse you CIColorMap!!!");
        }
    }
}

- (CGFloat)contentHeight
{
    FilterControlAttributesTableViewController *attributesVC = self.viewControllers[0];
    return [attributesVC contentHeight];
}

- (void)notifyDelegateOfFilterChange
{
    if ([self.filterControlsDelegate respondsToSelector:@selector(filterControlsViewController:didChangeFilterConfiguration:)]) {
        [self.filterControlsDelegate filterControlsViewController:self didChangeFilterConfiguration:self.filter];
    }
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    return nil;
}


@end
