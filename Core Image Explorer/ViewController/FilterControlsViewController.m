//
// Created by Joshua Sullivan on 4/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterControlsViewController.h"
#import "FilterControlAttributesTableViewController.h"

static NSString * const kStoryboardIdentifier = @"FilterControls";
static NSString * const kEmbedNavControllerSegueIdentifier = @"kEmbedNavControllerSegueIdentifier";

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
    self.delegate = self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    FilterControlAttributesTableViewController *attributesVC = self.viewControllers[0];
    attributesVC.filter = self.filter;
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
