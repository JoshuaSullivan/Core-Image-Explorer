//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "ScalarInputViewController.h"
@import CoreImage;

typedef NS_ENUM(NSInteger, ValuePrecision) {
    ValuePrecisionInteger = 0,
    ValuePrecisionSingle,
    ValuePrecisionDouble
};

@interface ScalarInputViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *gaugeImageView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (assign, nonatomic) ValuePrecision precision;
@property (strong, nonatomic) NSNumberFormatter *valueFormatter;

@end

@implementation ScalarInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *configDict = self.filter.attributes[self.inputKeyToConfigure];
    self.valueDefault = [configDict[kCIAttributeDefault] doubleValue];
    self.valueMin = [configDict[kCIAttributeSliderMin] doubleValue];
    self.valueMax = [configDict[kCIAttributeSliderMax] doubleValue];

    double difference = fabs(self.valueMax - self.valueMin);
    double logDiff = fmin(3.0, log10(difference));
    self.precision = (ValuePrecision)(2 - (NSInteger)logDiff);
    self.valueFormatter = [[NSNumberFormatter alloc] init];
    self.valueFormatter.usesGroupingSeparator = YES;
    switch (self.precision) {
        case ValuePrecisionInteger:
            self.valueFormatter.maximumFractionDigits = 0;
            self.valueFormatter.alwaysShowsDecimalSeparator = NO;
            break;
        case ValuePrecisionSingle:
            self.valueFormatter.minimumFractionDigits = 1;
            self.valueFormatter.maximumFractionDigits = 1;
            self.valueFormatter.alwaysShowsDecimalSeparator = YES;
            break;
        case ValuePrecisionDouble:
            self.valueFormatter.minimumFractionDigits = 2;
            self.valueFormatter.maximumFractionDigits = 2;
            self.valueFormatter.alwaysShowsDecimalSeparator = YES;
            break;
    }
    self.scrollView.scrollsToTop = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGSize gaugeSize = self.gaugeImageView.image.size;
    CGFloat halfScrollWidth = scrollViewSize.width / 2.0f;
    self.gaugeImageView.frame = CGRectMake(0.0f, scrollViewSize.height - gaugeSize.height, gaugeSize.width, gaugeSize.height);
    self.scrollView.contentSize = gaugeSize;

    self.value = [self.filter valueForKey:self.inputKeyToConfigure];
}

- (void)viewDidLayoutSubviews
{
    CGFloat subPixelOffset = 1.0f / self.gaugeImageView.image.scale;
    CGFloat w = self.scrollView.bounds.size.width / 2.0f;
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, w - subPixelOffset, 0.0f, w);
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

- (void)setValue:(NSNumber *)value
{
    _value = value;
    self.valueLabel.text = [self.valueFormatter stringFromNumber:value];
    CGFloat floatValue = [value floatValue];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat gaugeWidth = self.gaugeImageView.image.size.width;
    CGFloat x = scrollView.contentOffset.x;
    CGFloat ratio = x / gaugeWidth;
    NSLog(@"v: %0.2f", ratio);
}


@end
