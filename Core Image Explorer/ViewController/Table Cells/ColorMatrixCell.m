//
//  ColorMatrixCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/27/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "ColorMatrixCell.h"

@interface ColorMatrixCell ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ColorMatrixCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    [self updateValueLabel];
    
    NSLog(@"%@", self.inputName);
    
    CIVector *vec = (CIVector *)self.value;
    self.redSlider.value = vec.X;
    self.greenSlider.value = vec.Y;
    self.blueSlider.value = vec.Z;
    self.alphaSlider.value = vec.W;
}

- (void)updateValueLabel
{
    CIVector *vec = (CIVector *)self.value;
    self.valueLabel.text = [NSString stringWithFormat:@"[%.2f, %.2f, %.2f, %.2f]", vec.X, vec.Y, vec.Z, vec.W];
}

#pragma mark - IBActions

- (IBAction)sliderValueChanged:(id)sender
{
    self.value = [CIVector vectorWithX:self.redSlider.value
                                     Y:self.greenSlider.value
                                     Z:self.blueSlider.value
                                     W:self.alphaSlider.value];
    [self updateValueLabel];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
