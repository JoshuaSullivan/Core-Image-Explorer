//
//  NumericSliderCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "NumericSliderCell.h"

@interface NumericSliderCell ()

@property (weak, nonatomic) IBOutlet UILabel *inputValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (assign, nonatomic) BOOL isColorCube;

@end

@implementation NumericSliderCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary startingValue:value andInputName:inputName];
    
    NSNumber *minValue;
    NSNumber *maxValue;
    
    if (self.attributes[kCIAttributeSliderMin]) {
        minValue = self.attributes[kCIAttributeSliderMin];
        maxValue = self.attributes[kCIAttributeSliderMax];
    } else {
        minValue = self.attributes[kCIAttributeMin];
        maxValue = self.attributes[kCIAttributeMax];
    }
    
    self.slider.minimumValue = minValue.floatValue;
    self.slider.maximumValue = maxValue.floatValue;
    self.slider.value = ((NSNumber *)self.value).floatValue;
    
    self.minValueLabel.text = [NSString stringWithFormat:@"%.1f", minValue.floatValue];
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.1f", maxValue.floatValue];
    self.inputValueLabel.text = [NSString stringWithFormat:@"%.2f", ((NSNumber *)self.value).floatValue];
    
    
}

#pragma mark - Override the filter-provided input ranges.
- (void)setInputRangeMinValue:(NSNumber *)minValue
                     maxValue:(NSNumber *)maxValue
              andDefaultValue:(NSNumber *)defaultValue
{
    self.slider.minimumValue = minValue.floatValue;
    self.slider.maximumValue = maxValue.floatValue;
    if (defaultValue) {
        self.slider.value = defaultValue.floatValue;
        self.value = defaultValue;
    } else {
        self.slider.value = minValue.floatValue;
        self.value = minValue;
    }
    
    self.minValueLabel.text = [NSString stringWithFormat:@"%.1f", minValue.floatValue];
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.1f", maxValue.floatValue];
    self.inputValueLabel.text = [NSString stringWithFormat:@"%.2f", ((NSNumber *)self.value).floatValue];
}

#pragma mark - IBActions

- (IBAction)sliderValueDidChange:(id)sender
{
    float v = self.slider.value;
    if ([self.inputName isEqualToString:@"inputCubeDimension"]) {
        v = powf(2.0, floorf(log2f(v)));
    }
    self.inputValueLabel.text = [NSString stringWithFormat:@"%.2f", v];
    self.value = [NSNumber numberWithFloat:v];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
