//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "BaseConfigurationViewController.h"

@interface BaseConfigurationViewController ()

@end

@implementation BaseConfigurationViewController

@synthesize filter = _filter;
@synthesize inputKeyToConfigure = _inputKeyToConfigure;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *defaultButton = [[UIBarButtonItem alloc] initWithTitle:@"Default" style:UIBarButtonItemStylePlain target:self action:@selector(defaultButtonTapped:)];
    self.navigationItem.rightBarButtonItem = defaultButton;

    NSDictionary *configDict = self.filter.attributes[self.inputKeyToConfigure];
    if (!configDict) {
        NSAssert(NO, @"ERROR: No input found for key '%@'.", self.inputKeyToConfigure);
        return;
    }

    if (![self isControlSuitableForInput:configDict]) {
        NSAssert(NO, @"This this control is not appropriate for the input '%@'.", self.inputKeyToConfigure);
        return;
    }
}

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSAssert(NO, @"ERROR: Child classes must override isControlSuitableForInput:");
    return NO;
}

- (CGSize)controlSize
{
    NSAssert(NO, @"ERROR: Child classes must override the getter for controlSize");
    return CGSizeZero;
}

- (IBAction)defaultButtonTapped:(id)sender
{
    NSDictionary *configDict = self.filter.attributes[self.inputKeyToConfigure];
    id defaultValue = configDict[kCIAttributeDefault];
    [self.filter setValue:defaultValue forKey:self.inputKeyToConfigure];

    if ([self.filterConfigurationDelegate respondsToSelector:@selector(filterConfigurationControl:didModifyFilter:)]) {
        [self.filterConfigurationDelegate filterConfigurationControl:self didModifyFilter:self.filter];
    }
}

@end
