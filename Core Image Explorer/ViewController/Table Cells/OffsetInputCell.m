//
//  OffsetInputCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 11/3/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "OffsetInputCell.h"

@interface OffsetInputCell ()

@property (weak, nonatomic) IBOutlet UISlider *xSlider;
@property (weak, nonatomic) IBOutlet UISlider *ySlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation OffsetInputCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    
    CIVector *offset = (CIVector *)self.value;
    self.xSlider.value = offset.X;
    self.ySlider.value = offset.Y;
    
    [self updateValueLabel];
}

- (void)updateValueLabel
{
    CIVector *offset = (CIVector *)self.value;
    self.valueLabel.text = [NSString stringWithFormat:@"[%0.2f, %0.2f]", offset.X, offset.Y];
}

#pragma mark - Set the input ranges.
- (void)setSliderRangeMinX:(CGFloat)minX maxX:(CGFloat)maxX minY:(CGFloat)minY maxY:(CGFloat)maxY
{
    self.xSlider.minimumValue = minX;
    self.xSlider.maximumValue = maxX;
    self.ySlider.minimumValue = minY;
    self.ySlider.maximumValue = maxY;
}

#pragma mark - IBActions
- (IBAction)sliderValueChanged:(id)sender
{
    self.value = [CIVector vectorWithX:self.xSlider.value
                                     Y:self.ySlider.value];
    [self updateValueLabel];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
