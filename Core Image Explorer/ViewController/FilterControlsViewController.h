//
// Created by Joshua Sullivan on 4/5/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;

@class CIFilter;
@protocol FilterControlsDelegate;

@interface FilterControlsViewController : UINavigationController

@property (weak, nonatomic) id <FilterControlsDelegate> filterControlsDelegate;

- (instancetype)initWithFilter:(CIFilter *)filter;

@end

@protocol FilterControlsDelegate

- (void)filterControlsViewController:(FilterControlsViewController *)filterControlsViewController
        didChangeFilterConfiguration:(CIFilter *)filter;

@end
