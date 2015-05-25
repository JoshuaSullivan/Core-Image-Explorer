//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "ColorInputIntermediate.h"
#import "MinimalistInputViewController.h"
#import "InputIntermediateDelegate.h"
#import "MinimalistInputDescriptor.h"

typedef NS_ENUM(NSInteger, ColorComponent) {
    ColorComponentRed,
    ColorComponentGreen,
    ColorComponentBlue,
    ColorComponentAlpha
};

@interface ColorInputIntermediate () <MinimalistControlDelegate>

@property (assign, nonatomic) CGFloat r;
@property (assign, nonatomic) CGFloat g;
@property (assign, nonatomic) CGFloat b;
@property (assign, nonatomic) CGFloat a;
@property (strong, nonatomic) MinimalistInputViewController *inputVC;

@end

@implementation ColorInputIntermediate

- (instancetype)initWithInput:(NSString *)inputName forFilter:(CIFilter *)filter
{
    self = [super initWithInput:inputName forFilter:filter];
    if (!self) {
        NSAssert(NO, @"ERROR: Unable to instantiate ColorInputIntermediate.");
        return nil;
    }
    CIColor *startingColor = self.inputStartingValue;
    _r = startingColor.red;
    _g = startingColor.green;
    _b = startingColor.blue;
    _a = startingColor.alpha;
    _includeAlphaComponent = YES;

    return self;
}


- (UIViewController *)inputViewController
{
    if (!self.inputVC) {
        NSString *red = NSLocalizedString(@"Red", @"Red");
        NSString *green = NSLocalizedString(@"Green", @"Green");
        NSString *blue = NSLocalizedString(@"Blue", @"Blue");
        NSString *alpha = NSLocalizedString(@"Alpha", @"Alpha");
        NSDictionary *componentValues = @{
                red : @(self.r),
                green : @(self.g),
                blue : @(self.b),
                alpha : @(self.a)
        };
        NSDictionary *tintColors = @{
                red : [UIColor redColor],
                green : [UIColor greenColor],
                blue : [UIColor blueColor],
                alpha : [UIColor whiteColor]
        };
        NSArray *components = @[red, green, blue];
        if (self.includeAlphaComponent) {
            components = [components arrayByAddingObject:alpha];
        }
        NSMutableArray *descriptors = [NSMutableArray arrayWithCapacity:components.count];
        for (NSString *component in components) {
            CGFloat value = [componentValues[component] floatValue];
            MinimalistInputDescriptor *descriptor = [MinimalistInputDescriptor inputDescriptorWithTitle:component
                                                                                               minValue:0.0f
                                                                                               maxValue:1.0f
                                                                                          startingValue:value];
            descriptor.tintColor = tintColors[component];
            [descriptors addObject:descriptor];
        }
        self.inputVC = [MinimalistInputViewController minimalistControlForDescriptors:descriptors];
        self.inputVC.delegate = self;
    }

    return self.inputVC;
}

#pragma mark - MinimalistControlDelegate

- (void)minimalistControl:(MinimalistInputViewController *)minimalistControl didSetValue:(CGFloat)value forInputIndex:(NSInteger)index
{
    switch ((ColorComponent)index) {
        case ColorComponentRed:
            self.r = value;
            break;
        case ColorComponentGreen:
            self.g = value;
            break;
        case ColorComponentBlue:
            self.b = value;
            break;
        case ColorComponentAlpha:
            self.a = value;
            break;
    }
    CIColor *newColor = [CIColor colorWithRed:self.r green:self.g blue:self.b alpha:self.a];
    if ([self.delegate respondsToSelector:@selector(inputIntermediate:didSetValue:forInput:)]) {
        [self.delegate inputIntermediate:self didSetValue:newColor forInput:self.inputName];
    }
}

- (void)minimalistControlShouldClose:(MinimalistInputViewController *)minimalistController
{
    if ([self.delegate respondsToSelector:@selector(inputIntermedateDidComplete:)]) {
        [self.delegate inputIntermedateDidComplete:self];
    }
}

@end