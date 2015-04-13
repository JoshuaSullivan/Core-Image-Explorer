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

@property (assign, nonatomic) CGFloat pixelWidth;

@property (assign, nonatomic) BOOL isInitialLayout;

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
    self.valueFormatter.minimumIntegerDigits = 1;
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
    self.pixelWidth = 1.0f / self.gaugeImageView.image.scale;
    self.isInitialLayout = YES;
    self.value = [self.filter valueForKey:self.inputKeyToConfigure];
    self.scrollView.contentSize = self.gaugeImageView.image.size;
}

- (void)viewDidLayoutSubviews
{
    if (self.isInitialLayout) {
        [self calibrateGaugeToWidth:self.view.bounds.size.width];
        self.isInitialLayout = NO;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self calibrateGaugeToWidth:size.width];
}

- (void)calibrateGaugeToWidth:(CGFloat)width
{
    CGFloat w = width / 2.0f;
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, w - self.pixelWidth, 0.0f, w);
    [self syncGaugeToValue];
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
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat gaugeWidth = self.gaugeImageView.image.size.width;
    CGFloat x = scrollView.contentOffset.x + scrollView.contentInset.left;
    double ratio = fmax(0.0, fmin(x / (gaugeWidth - self.pixelWidth), 1.0));
    double value = ratio * (self.valueMax - self.valueMin) + self.valueMin;
    self.value = @(value);
}

- (void)syncGaugeToValue
{
    double ratio = ([self.value doubleValue] - self.valueMin) / (self.valueMax - self.valueMin);
    CGFloat gaugeWidth = self.gaugeImageView.image.size.width;
    CGFloat x = (CGFloat)ratio * gaugeWidth - self.scrollView.contentInset.left;
    [self.scrollView setContentOffset:CGPointMake(x, 0.0f) animated:NO];
}

@end
