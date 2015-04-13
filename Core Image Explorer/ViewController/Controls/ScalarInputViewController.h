//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "BaseConfigurationViewController.h"

@interface ScalarInputViewController : BaseConfigurationViewController

@property (strong, nonatomic) NSNumber *value;

@property (assign, nonatomic) double valueMin;
@property (assign, nonatomic) double valueMax;
@property (assign, nonatomic) double valueDefault;

@end
