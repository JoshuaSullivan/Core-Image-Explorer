//
// ImageInputViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "ImageInputViewController.h"

@interface ImageInputViewController ()

@end

@implementation ImageInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSString *attributeType = inputDictionary[kCIAttributeType];
    return [attributeType isEqualToString:kCIAttributeTypeImage];
}


@end
