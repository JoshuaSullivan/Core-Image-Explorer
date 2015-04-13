//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "ScalarInputViewController.h"
@import CoreImage;

@interface ScalarInputViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *gaugeImageView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ScalarInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO: Configure views.
}

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSString *inputType = inputDictionary[kCIAttributeType];
    return [inputType isEqualToString:kCIAttributeTypeScalar];
}

- (CGSize)controlSize
{
    return CGSizeMake(300.0f, 100.0f);
}

@end
