//
// Created by Joshua Sullivan on 4/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterControlsViewController.h"
#import "FilterAttributesListViewController.h"
#import "SampleImageManager.h"
#import "AbstractInputIntermediate.h"
#import "InputIntermediateFactory.h"

static NSString * const kStoryboardIdentifier = @"FilterControls";
static NSString * const kEmbedNavControllerSegueIdentifier = @"kEmbedNavControllerSegueIdentifier";

static NSString * const kGradientImageKey = @"inputGradientImage";

@interface FilterControlsViewController () <UINavigationControllerDelegate, FilterAttributeListDelegate, InputIntermediateDelegate>

@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) AbstractInputIntermediate *currentIntermediate;

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

    FilterAttributesListViewController *attributesVC = self.viewControllers[0];
    attributesVC.filter = self.filter;
    attributesVC.attributeListDelegate = self;
}

- (void)setDefaultImagesOnFilter:(CIFilter *)filter
{
    //TODO: I need to track which ImageSource is assigned to each image-based input so that it can be updated properly on orientation change.
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
    FilterAttributesListViewController *attributesVC = self.viewControllers[0];
    return [attributesVC contentHeight];
}

- (void)notifyDelegateOfFilterChange
{
    if ([self.filterControlsDelegate respondsToSelector:@selector(filterControlsViewController:didSetValue:forAttribute:onFilter:)]) {
        [self.filterControlsDelegate filterControlsViewController:self
                                                      didSetValue:self.filter
                                                     forAttribute:nil
                                                         onFilter:nil];
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

#pragma mark - Control Presentation

- (void)presentControlForInput:(NSString *)inputName
{
    self.currentIntermediate = [InputIntermediateFactory createIntermediateForInput:inputName forFilter:self.filter];
    self.currentIntermediate.delegate = self;
    UIViewController *inputVC = self.currentIntermediate.inputViewController;
    [self presentViewController:inputVC animated:YES completion:nil];
    self.view.hidden = YES;
    [self.filterControlsDelegate filterControlsViewController:self didRequestFullScreen:YES];
}

#pragma mark - FilterAttributeListDelegate

- (void)filterAttributesList:(FilterAttributesListViewController *)attributeListVC didSelectInput:(NSString *)inputName
{
    [self presentControlForInput:inputName];
}

#pragma mark - InputIntermediateDelegate

- (void)inputIntermediate:(id)inputIntermediate didSetValue:(id)value forInput:(NSString *)inputName
{
    [self.filter setValue:value forKey:inputName];
    if ([self.filterControlsDelegate respondsToSelector:@selector(filterControlsViewController:didSetValue:forAttribute:onFilter:)]) {
        [self.filterControlsDelegate filterControlsViewController:self
                                                      didSetValue:value
                                                     forAttribute:inputName
                                                         onFilter:self.filter];
    }
}

- (void)inputIntermedateDidComplete:(id)inputIntermediate
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.view.hidden = NO;
    self.currentIntermediate = nil;
}


@end
