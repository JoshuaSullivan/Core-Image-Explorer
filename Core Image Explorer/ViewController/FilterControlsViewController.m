//
// Created by Joshua Sullivan on 4/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterControlsViewController.h"
#import "FilterAttributesListViewController.h"
#import "SampleImageManager.h"
#import "MinimalistInputDescriptor.h"
#import "MinimalistInputViewController.h"

static NSString * const kStoryboardIdentifier = @"FilterControls";
static NSString * const kEmbedNavControllerSegueIdentifier = @"kEmbedNavControllerSegueIdentifier";

static NSString * const kGradientImageKey = @"inputGradientImage";

@interface FilterControlsViewController () <UINavigationControllerDelegate, MinimalistControlDelegate, FilterAttributeListDelegate>

@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) NSString *inputKeyToConfigure;

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

#pragma mark - Control Presentation

- (void)presentControlForInput:(NSString *)inputKey
{
    self.inputKeyToConfigure = inputKey;
    NSDictionary *attributes = self.filter.attributes[inputKey];
    NSString *type = attributes[kCIAttributeType];
    if ([type isEqualToString:kCIAttributeTypeScalar]) {
        NSNumber *minValueNumber = attributes[kCIAttributeSliderMin];
        NSNumber *maxValueNumber = attributes[kCIAttributeSliderMax];
        NSNumber *currentValueNumber = [self.filter valueForKey:inputKey];
        CGFloat minValue = minValueNumber ? [minValueNumber floatValue] : 0.0f;
        CGFloat maxValue = maxValueNumber ? [maxValueNumber floatValue] : minValue + 1.0f;
        CGFloat currentValue = currentValueNumber ? [currentValueNumber floatValue] : minValue;
        MinimalistInputDescriptor *descriptor = [MinimalistInputDescriptor inputDescriptorWithTitle:inputKey
                                                                                           minValue:minValue
                                                                                           maxValue:maxValue
                                                                                      startingValue:currentValue];
        MinimalistInputViewController *scalarVC = [[MinimalistInputViewController alloc] initWithInputCount:1
                                                                                           inputDescriptors:@[descriptor]];
        scalarVC.delegate = self;
        [self presentViewController:scalarVC
                           animated:YES
                         completion:nil];
        self.view.hidden = YES;
        [self.filterControlsDelegate filterControlsViewController:self didRequestFullScreen:YES];
    }
}

#pragma mark - FilterAttributeListDelegate

- (void)filterAttributesList:(FilterAttributesListViewController *)attributeListVC didSelectInput:(NSString *)input
{
    [self presentControlForInput:input];
}

#pragma mark - MinimalistControlDelegate

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index
{
    [self.filter setValue:@(value) forKey:self.inputKeyToConfigure];
    [self notifyDelegateOfFilterChange];
}

- (void)minimalistControlShouldClose:(MinimalistInputViewController *)minimalistController
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.view.hidden = NO;
        [self.filterControlsDelegate filterControlsViewController:self didRequestFullScreen:NO];
    }];
}



@end
