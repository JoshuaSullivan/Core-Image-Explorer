//
//  ColorPickerCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/23/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ColorPickerCell.h"

@interface ColorPickerCell ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UILabel *redValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueValueLabel;
@property (weak, nonatomic) IBOutlet UIView *colorPreviewView;

@property (readonly, nonatomic) CIColor *colorValue;

@end

@implementation ColorPickerCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    
    self.redSlider.value = self.colorValue.red;
    self.greenSlider.value = self.colorValue.green;
    self.blueSlider.value = self.colorValue.blue;
    
    [self updateValueFields];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.colorPreviewView.layer.cornerRadius = 3.0;
    self.colorPreviewView.layer.borderColor = [UIColor blackColor].CGColor;
    self.colorPreviewView.layer.borderWidth = 1.0;
    
    [self updateValueFields];
}

#pragma mark - Refresh the value fields
- (void)updateValueFields
{
    self.redValueLabel.text = [NSString stringWithFormat:@"%0.3f", self.colorValue.red];
    self.greenValueLabel.text = [NSString stringWithFormat:@"%0.3f", self.colorValue.green];
    self.blueValueLabel.text = [NSString stringWithFormat:@"%0.3f", self.colorValue.blue];
    
    self.colorPreviewView.backgroundColor = [UIColor colorWithRed:self.colorValue.red
                                                            green:self.colorValue.green
                                                             blue:self.colorValue.blue
                                                            alpha:1.0];
}

#pragma mark - IBActions
- (IBAction)sliderValueDidChange:(id)sender
{
    CGFloat r = self.colorValue.red;
    CGFloat g = self.colorValue.green;
    CGFloat b = self.colorValue.blue;
    
    if (sender == self.redSlider) {
        r = self.redSlider.value;
    } else if (sender == self.greenSlider) {
        g = self.greenSlider.value;
    } else {
        b = self.blueSlider.value;
    }
    
    self.value = [CIColor colorWithRed:r green:g blue:b];
    [self updateValueFields];
    [self.delegate inputControlCellValueDidChange:self];
}

#pragma mark - Custom accessor
- (CIColor *)colorValue
{
    return (CIColor *)self.value;
}

@end
